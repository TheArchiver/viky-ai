require 'test_helper'

module Valgrind

  class ValgrindCommon < Nls::Common

    def setup

      resetDir

      # copy import file
      cp_import_fixture("several_packages_several_intents.json")

    end

    def interpret_queries(nb_simple, nb_timeout, nb_pkg_update)

      interpret_simple_query=
      {
        "packages" => ["voqal.ai:datetime1"],
        "sentence" => "Hello Jean Marie",
        "Accept-Language" => "fr-FR"
      }

      # launch simple query
      nb_simple.times do
        response = Nls::Nls.interpret(interpret_simple_query)
        assert !response.nil?
      end

      hello_world_query = {
        timeout: 20,
        timeout_in: "NlpPackageGet"
      }

      # launch hello world query with timeout
      expected_error = "NlsCancelCleanupOnTimeout : Request timeout after"
      nb_timeout.times do |i|
        exception = assert_raises RestClient::ExceptionWithResponse do
          Nls::Nls.interpret(interpret_simple_query, hello_world_query)
        end
        assert_response_has_error expected_error, exception, "Timeout #{i}"
      end


      json_package_to_update = JSON.parse(File.read(fixture_path("package_to_update.json")))
      url_add = Nls::Nls.url_packages + "/voqal.ai:datetime2"

      expected_update_result =
      {
        "status" => "Package 'voqal.ai:datetime2' successfully updated"
      }

      nb_pkg_update.times do |i|
        actual_update_result = Nls::Nls.query_post(url_add, json_package_to_update)
        assert_json expected_update_result, actual_update_result, "updating #{i}"
      end

    end


  end
end