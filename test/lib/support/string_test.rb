require "test_helper"

class StringTest < ActiveSupport::TestCase

  should "extract_settings" do
    assert_equal %w( a b c ), "a, b, c".extract_settings
    assert_equal %w( a b c ), " a  , b,  c ".extract_settings
  end

  context "remove_prefix" do

    should "return strings without default prefix" do
      assert_equal "posts", "admin/posts".remove_prefix
      assert_equal "typus_users", "admin/typus_users".remove_prefix
      assert_equal "delayed/jobs", "admin/delayed/jobs".remove_prefix
    end

    should "return strings without custom prefix" do
      assert_equal "posts", "typus/posts".remove_prefix
      assert_equal "typus_users", "typus/typus_users".remove_prefix
      assert_equal "delayed/tasks", "typus/delayed/tasks".remove_prefix
    end

  end

  context "extract_class" do

    setup do
      Typus::Configuration.models_constantized = { "Post" => Post,
                                                   "TypusUser" => TypusUser,
                                                   "Delayed::Task" => Delayed::Task,
                                                   "SucursalBancaria" => SucursalBancaria }
    end

    should "work for models" do
      assert_equal Post, "admin/posts".extract_class
      assert_equal TypusUser, "admin/typus_users".extract_class
    end

    should "work for namespaced models" do
      assert_equal Delayed::Task, "admin/delayed/tasks".extract_class
    end

    should "work with inflections" do
      assert_equal SucursalBancaria, "admin/sucursales_bancarias".extract_class
    end

  end

  context "action_mapper" do

    should "return list for index" do
      assert_equal :list, 'index'.action_mapper
    end

    should "return form for new, create, edit and update" do
      %w(new create edit update).each do |action|
        assert_equal :form, action.action_mapper
      end
    end

    should "return the same action for everything else" do
      assert_equal 'undefined', 'undefined'.action_mapper
    end

  end

end
