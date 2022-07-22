# frozen_string_literal: true

shared_examples "SerializedRecord::FormBuilderHelper" do
  subject(:helper) { TestFormBuilder.new("test_professor", professor, controller.view_context, {}) }

  let(:controller) { ActionController::Base.new }
  let(:students) { Array.new(3) { TestStudent.new } }
  let(:professor) { TestProfessor.new(test_students: students) }
  let(:view_path) { Rails.root.join("spec", "fixtures", "views") }

  before { controller.prepend_view_path(view_path) }

  describe "#nested_form" do
    let(:output) do
      <<~HTML.strip
        <div data-nested-form="test_students"><input type="text" value="Krystian" name="test_professor[test_students_attributes][0][name]" id="test_professor_test_students_attributes_0_name" />
        <input value="1" disabled="disabled" data-nested-form-destroy-input="" autocomplete="off" type="hidden" name="test_professor[test_students_attributes][0][_destroy]" id="test_professor_test_students_attributes_0__destroy" /><button name="button" type="button" data-nested-form-destroy="">-</button>
        <input type="text" value="Krystian" name="test_professor[test_students_attributes][1][name]" id="test_professor_test_students_attributes_1_name" />
        <input value="1" disabled="disabled" data-nested-form-destroy-input="" autocomplete="off" type="hidden" name="test_professor[test_students_attributes][1][_destroy]" id="test_professor_test_students_attributes_1__destroy" /><button name="button" type="button" data-nested-form-destroy="">-</button>
        <input type="text" value="Krystian" name="test_professor[test_students_attributes][2][name]" id="test_professor_test_students_attributes_2_name" />
        <input value="1" disabled="disabled" data-nested-form-destroy-input="" autocomplete="off" type="hidden" name="test_professor[test_students_attributes][2][_destroy]" id="test_professor_test_students_attributes_2__destroy" /><button name="button" type="button" data-nested-form-destroy="">-</button>
        </div><script data-nested-form-template="test_students" type="text/html"><input type="text" value="Krystian" name="test_professor[test_students_attributes][{{index}}][name]" id="test_professor_test_students_attributes_{{index}}_name" />
        <input value="1" disabled="disabled" data-nested-form-destroy-input="" autocomplete="off" type="hidden" name="test_professor[test_students_attributes][{{index}}][_destroy]" id="test_professor_test_students_attributes_{{index}}__destroy" /><button name="button" type="button" data-nested-form-destroy="">-</button>
        </script>
      HTML
    end

    it "returns a form with fields_for and script for the association" do
      expect(helper.nested_form(:test_students)).to eq(output)
    end
  end

  describe "#create_button" do
    let(:output) do
      <<~HTML.strip
        <button name="button" type="button" class="btn" data-nested-form-create="test_students">+</button>
      HTML
    end

    it "creates the appropriate markup" do
      expect(helper.create_button(:test_students, "+", class: "btn")).to eq(output)
    end
  end

  describe "#destroy_button" do
    let(:output) do
      <<~HTML.strip.delete("\n")
        <input value="1" disabled="disabled" data-nested-form-destroy-input="" autocomplete="off" type="hidden" name="test_professor[_destroy]" id="test_professor__destroy" />
        <button name="button" type="button" class="btn" data-nested-form-destroy="">-</button>
      HTML
    end

    it "creates the appropriate markup" do
      expect(helper.destroy_button("-", class: "btn")).to eq(output)
    end
  end
end
