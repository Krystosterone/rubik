shared_examples "SerializedRecord::FormBuilderHelper" do
  let(:students) { Array.new(3) { double(TestStudent) } }
  let(:professor) { double(TestProfessor, class: TestProfessor, test_students: students) }
  let(:view_context) { double }
  let(:parent_builder) { double(ActionView::Helpers::FormBuilder, options: { url: "parent_url" }) }
  subject do
    TestFormBuilder.new("test_professor", professor, view_context, url: "form_url", parent_builder: parent_builder)
  end

  describe '#create_button' do
    before do
      allow(view_context)
        .to receive(:button_tag).with("+",
                                      name: "test_professor[test_students_attributes][3][_create]",
                                      value: 1,
                                      formaction: 'form_url/#test_students',
                                      class: "btn").and_return("markup")
    end

    it "creates the appropriate markup" do
      expect(subject.create_button(:test_students, "+", class: "btn"))
        .to eq("markup")
    end
  end

  describe '#destroy_button' do
    before do
      allow(view_context)
        .to receive(:button_tag).with("-",
                                      name: "test_professor[_destroy]",
                                      value: 1,
                                      formaction: 'parent_url/#test_professors',
                                      class: "btn").and_return("markup")
    end

    it "creates the appropriate markup" do
      expect(subject.destroy_button("-", class: "btn"))
        .to eq("markup")
    end
  end
end
