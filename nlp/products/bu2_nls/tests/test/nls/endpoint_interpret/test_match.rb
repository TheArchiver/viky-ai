# encoding: utf-8

require 'test_helper'

module Nls

  module EndpointInterpret

    class TestNlpMatch < NlsTestCommon

      def create_aller_de_a
        aller_de_a = Package.new("aller-de-a")

        i_new_york = Interpretation.new("new-york").new_textual(["New York", "NYC"])
        aller_de_a << i_new_york

        i_barca = Interpretation.new("barcelona").new_textual(["Barcelona", "Barca"])
        aller_de_a << i_barca

        i_town = Interpretation.new("town")
                    .new_expression("@{new-york}",  'new-york': i_new_york)
                    .new_expression("@{barcelona}", barcelona: i_barca)
        aller_de_a << i_town

        i_prep_from = Interpretation.new("prep-from").new_textual(["from"])
        aller_de_a << i_prep_from

        i_prep_to = Interpretation.new("prep-to").new_textual(["to"])
        aller_de_a << i_prep_to

        prep_from_town_hash = { 'prep-from': i_prep_from, town: i_town }
        i_prep_from_town = Interpretation.new("prep-from-town").new_expression("@{prep-from} @{town}", prep_from_town_hash)
        aller_de_a << i_prep_from_town

        prep_to_town_hash = { 'prep-to': i_prep_to, town: i_town }
        i_prep_to_town = Interpretation.new("prep-to-town").new_expression("@{prep-to} @{town}", prep_to_town_hash)
        aller_de_a << i_prep_to_town

        i_go = Interpretation.new("go").new_textual(["go"])
        aller_de_a << i_go

        go_from_to_hash = { go: i_go, from: i_prep_from_town, to: i_prep_to_town }
        i_go_from_to = Interpretation.new("go-from-to").new_expression("@{go} @{from} @{to}", go_from_to_hash)
        aller_de_a << i_go_from_to

        i_want = Interpretation.new("want").new_textual(["I want to"])
        aller_de_a << i_want

        want_go_from_to_hash = { want: i_want, 'go-from-to': i_go_from_to }
        i_want_go_from_to = Interpretation.new("want-go-from-to").new_expression("@{want} @{go-from-to}", want_go_from_to_hash)
        aller_de_a << i_want_go_from_to

        aller_de_a
      end

      def create_aller_de_a_any
        aller_de_a = Package.new("aller-de-a")

        i_prep_from = Interpretation.new("prep-from").new_textual(["from"])
        aller_de_a << i_prep_from

        i_prep_to = Interpretation.new("prep-to").new_textual(["to"])
        aller_de_a << i_prep_to

        prep_from_town_hash = { 'prep-from': i_prep_from, town: Alias.any }
        i_prep_from_town = Interpretation.new("prep-from-town").new_expression("@{prep-from} @{town}", prep_from_town_hash)
        aller_de_a << i_prep_from_town

        prep_to_town_hash = { 'prep-to': i_prep_to, town: Alias.any }
        i_prep_to_town = Interpretation.new("prep-to-town").new_expression("@{prep-to} @{town}", prep_to_town_hash)
        aller_de_a << i_prep_to_town

        i_go = Interpretation.new("go").new_textual(["go"])
        aller_de_a << i_go

        go_from_to_hash = { go: i_go, from: i_prep_from_town, to: i_prep_to_town }
        i_go_from_to = Interpretation.new("go-from-to").new_expression("@{go} @{from} @{to}", go_from_to_hash)
        aller_de_a << i_go_from_to

        i_want = Interpretation.new("want").new_textual(["I want to"])
        aller_de_a << i_want

        want_go_from_to_hash = { want: i_want, 'go-from-to': i_go_from_to }
        i_want_go_from_to = Interpretation.new("want-go-from-to").new_expression("@{want} @{go-from-to}", want_go_from_to_hash)
        aller_de_a << i_want_go_from_to

        aller_de_a
      end

      def create_building_feature
        pg_building_feature = Package.new("pg-building-feature")

        i_sea_view = Interpretation.new("sea-view").new_textual(["sea view", "sea front", "ocean view", "ocean front"])
        pg_building_feature << i_sea_view

        i_swimming_pool = Interpretation.new("swimming-pool").new_textual(["swimming pool", "pool"])
        pg_building_feature << i_swimming_pool

        i_building_feature = Interpretation.new("building-feature").new_expression("@{swimming-pool}",{'swimming-pool': i_swimming_pool})
                                                                   .new_expression("@{sea-view}",{'sea-view': i_sea_view})
        pg_building_feature << i_building_feature

        i_preposition_building_feature= Interpretation.new("preposition-building-feature").new_textual(["with", "at"])
        pg_building_feature << i_preposition_building_feature

        pg_building_feature_hash = {'preposition-building-feature': i_preposition_building_feature, 'building-feature': i_building_feature}
        i_pg_building_feature = Interpretation.new("pg-building-feature").new_expression("@{preposition-building-feature} @{building-feature}", pg_building_feature_hash)
                                                                         .new_expression("@{building-feature}", {'building-feature': i_building_feature})
        pg_building_feature << i_pg_building_feature

        i_pg_building_features = Interpretation.new("pg-building-features")
        pg_building_features_hash = {'pg-building-feature': i_pg_building_feature, 'pg-building-features': i_pg_building_features}
        i_pg_building_features.new_expression("@{pg-building-feature} @{pg-building-features}", pg_building_features_hash)
                              .new_expression("@{pg-building-feature}", {'pg-building-feature': i_pg_building_feature})
        pg_building_feature << i_pg_building_features

        pg_building_feature
      end

      def create_go_town_recursive
        go_town = Package.new("go-town")

        i_new_york = Interpretation.new("new-york").new_textual(["New York", "NYC"])
        go_town << i_new_york

        i_barca = Interpretation.new("barcelona").new_textual(["Barcelona", "Barca"])
        go_town << i_barca

        i_paris = Interpretation.new("paris").new_textual(["Paris", "Capital of France"])
        go_town << i_paris

        i_town = Interpretation.new("town")
                        .new_expression("@{new-york}", { 'new-york': i_new_york })
                        .new_expression("@{barcelona}", { barcelona: i_barca })
                        .new_expression("@{paris}", { paris: i_paris })
        go_town << i_town

        i_towns = Interpretation.new("towns")
        i_towns.new_expression("@{town} @{towns}", { town: i_town, towns: i_towns })
               .new_expression("@{town}", { town: i_town })
        go_town << i_towns

        i_go = Interpretation.new("go").new_textual(["go to"])
        go_town << i_go

        i_go_town = Interpretation.new("go-town").new_expression("@{go} @{towns}", { go: i_go, towns: i_towns })
        go_town << i_go_town

        go_town
      end

      def test_interpret_aller_de_a

        Interpretation.default_locale = "en-GB"

        aller_de_a = create_aller_de_a
        aller_de_a.to_file(importDir)

        Nls.restart

        # resultat attendu
        expected = expected_interpret_result(aller_de_a["want-go-from-to"])

        # creation et exécutio de la requete
        request = json_interpret_body(aller_de_a, "I want to go from Barcelona to New York", Interpretation.default_locale)
        actual = Nls.interpret(request)
        assert_equal expected, actual

      end

      def test_interpret_aller_de_a_any
        Interpretation.default_locale = "en-GB"

        aller_de_a = create_aller_de_a_any
        aller_de_a.to_file(importDir)

        Nls.restart

        #resultat attendu

        # creation et exécution de la requete 1
        request1 = json_interpret_body(aller_de_a, "I want to go from Tokyo to Paris", Interpretation.default_locale)
        expected = expected_interpret_result(aller_de_a["want-go-from-to"])
        add_solution_to_result(expected, 0, { "any" => ["Tokyo", "Paris"]})
        actual1 = Nls.interpret(request1)
        assert_equal expected, actual1

        # creation et exécution de la requete 2
        request2 = json_interpret_body(aller_de_a, "I want to go from New York to Barcelona", Interpretation.default_locale)
        expected = expected_interpret_result(aller_de_a["want-go-from-to"])
        add_solution_to_result(expected, 0, { "any" => ["New York", "Barcelona"]})
        actual2 = Nls.interpret(request2)
        assert_equal expected, actual2

        # creation et exécution de la requete 3
        request3 = json_interpret_body(aller_de_a, "I want to go from New York to Paris", Interpretation.default_locale)
        expected = expected_interpret_result(aller_de_a["want-go-from-to"])
        add_solution_to_result(expected, 0, { "any" => ["New York", "Paris"]})
        actual3 = Nls.interpret(request3)
        assert_equal expected, actual3
      end

      def test_interpret_recursive

        Interpretation.default_locale = "en-GB"

        # creation du feed d'init
        go_town = create_go_town_recursive
        go_town.to_file(importDir)

        Nls.restart

        expected = expected_interpret_result(go_town["go-town"])

         # creation et exécution de la requete
        request = json_interpret_body(go_town, "go to Paris New York Barcelona", Interpretation.default_locale)
        actual = Nls.interpret(request)
        assert_equal expected, actual

      end

      def test_interpret_builtin_features
        Interpretation.default_locale = "en-GB"

        # feed building features
        pg_building_feature = create_building_feature
        pg_building_feature.to_file(importDir)

        # feed want hotel
        want_hotel = Package.new("want-hotel")

        i_want = Interpretation.new("want").new_textual(["I want", "I need", "I search", "I'm looking for"])
        want_hotel << i_want

        i_hotel = Interpretation.new("hotel").new_textual(["an hotel"])
        want_hotel << i_hotel

        i_want_hotel = Interpretation.new("want-hotel").new_expression("@{want} @{hotel}", {want: i_want, hotel: i_hotel})
        want_hotel << i_want_hotel

        want_hotel_with_feature_hash = {'want-hotel': i_want_hotel, 'pg-building-features': pg_building_feature["pg-building-features"]}
        i_want_hotel_with_feature = Interpretation.new("want-hotel-with-feature")
                                                  .new_expression("@{want-hotel} @{pg-building-features}", want_hotel_with_feature_hash)
        want_hotel << i_want_hotel_with_feature

        want_hotel.to_file(importDir)

        # deroulement du test
        Nls.restart

        #resultat attendu
        expected = expected_interpret_result(i_want_hotel_with_feature)

        # creation et exécution de la requete
        request = json_interpret_body([want_hotel, pg_building_feature], "I want an hotel with swimming pool with sea view", Interpretation.default_locale)
        actual = Nls.interpret(request)
        assert_equal expected, actual

      end

      def test_building_features
        Interpretation.default_locale = "en-GB"

        # feed building features
        pg_building_feature = create_building_feature
        pg_building_feature.to_file(importDir)

        Nls.restart

        # resultat attendu
        expected = expected_interpret_result(pg_building_feature["pg-building-features"])

        # creation et exécution de la requete
        request = json_interpret_body(pg_building_feature, "with swimming pool with sea view", Interpretation.default_locale)
        actual = Nls.interpret(request)
        assert_equal expected, actual
      end

      def test_building_features_any
        Interpretation.default_locale = "en-GB"

        # feed building feature_any
        pg_building_feature_any = create_building_feature_any
        pg_building_feature_any.to_file(importDir)

        # deroulement du test
        Nls.restart

        # resultat attendu
        expected = expected_interpret_result(pg_building_feature_any["pg-building-features"])
        add_solution_to_result(expected, 0, { "any" => ["golf", "spa"]})

        # creation et exécution de la requete
        request = json_interpret_body(pg_building_feature_any, "with swimming pool with golf with sea view with spa", Interpretation.default_locale)
        actual = Nls.interpret(request)
        assert_equal expected, actual
      end
    end
  end

end
