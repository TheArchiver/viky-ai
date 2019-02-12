import Vue from 'vue/dist/vue.esm'

class ConsoleExplain
  constructor: ->
    if $('#console-intent-footer').length == 1
      App.ConsoleExplainFooter = new Vue({
        el: '#console-intent-footer',
        data: {
          test: regression_check
        },
        computed: {
          testExists: () ->
            if this.test.id == null then false else true
        },
        methods: {
          updateTest: (packageId, id, score, solution) ->
            csrfToken = $('meta[name="csrf-token"]').attr('content')
            updateUrl = this.test.update_url
            $.ajax
                url: updateUrl,
                method: "PUT",
                headers: {
                  "X-CSRF-TOKEN": csrfToken
                },
                data:{
                  regression_check: {
                    expected: {
                      package: packageId,
                      id: id,
                      solution: solution
                    }
                  }
                }
                error: (data) =>
                  App.Message.alert(data.responseText)

          addTest: (packageId, id, score, solution) ->
            csrfToken = $('meta[name="csrf-token"]').attr('content')
            createUrl = this.test.create_url
            $.ajax
                url: createUrl,
                method: "POST",
                headers: {
                  "X-CSRF-TOKEN": csrfToken
                },
                data:{
                  regression_check: {
                    sentence: this.test.sentence,
                    language: this.test.language,
                    now: this.test.now,
                    expected: {
                      package: packageId,
                      id: id,
                      solution: solution
                    }
                  }
                }
        }
      })
    else
      App.ConsoleExplainFooter = null



Setup = ->
 $("body").on 'console:load_explain_footer', (event) =>
  new ConsoleExplain()

$(document).on('turbolinks:load', Setup)
