class AgentTransfer

  attr_accessor :errors, :agent, :previous_owner, :new_owner

  def initialize(agent, new_owner_id)
    @errors = []
    @agent = agent

    @previous_owner = @agent.owner
    @new_owner = User.find_by(id: new_owner_id)
  end

  def valid?
    @errors.empty?
  end

  def proceed
    validate
    if valid?
      ActiveRecord::Base.transaction do
        downgrade_previous_ownership
        new_ownership = create_new_ownership
        if new_ownership.save
          @agent.owner_id = @new_owner.id
          unless @agent.save
            @errors << @agent.errors.full_messages
            raise ActiveRecord::Rollback
          end
          @agent.users.reload
        else
          @errors << new_ownership.errors.full_messages
          raise ActiveRecord::Rollback
        end
      end
      AgentMailer.transfer_ownership(@previous_owner, @new_owner, @agent).deliver_later
    end
  end

  private

    def validate
      @errors = []
      validate_new_owner
      validate_agent_slug_availability if valid?
    end

    def validate_new_owner
      if @new_owner.nil?
        @errors << I18n.t('errors.agent.transfer_ownership.invalid_username')
      end
    end

    def validate_agent_slug_availability
      if Agent.where(owner_id: @new_owner.id, agentname: @agent.agentname).count != 0
        @errors << I18n.t('errors.agent.transfer_ownership.duplicate_agentname')
      end
    end

    def downgrade_previous_ownership
      previous_ownership = Membership.find_by(user_id: @agent.owner_id, agent_id: @agent.id)
      previous_ownership.rights = 'edit'
      previous_ownership.save!
    end

    def create_new_ownership
      new_membership = Membership.find_by(agent_id: @agent.id, user_id: @new_owner.id)
      if new_membership.present?
        new_membership.rights = 'all'
      else
        new_membership = Membership.new(agent_id: @agent.id, user_id: @new_owner.id, rights: 'all')
      end
      new_membership
    end

end
