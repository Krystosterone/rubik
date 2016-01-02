shared_examples 'SerializedRecord::FormBuilderHelper' do
  let(:students) { 3.times.collect { double(Student) } }
  let(:professor) { double(Professor, class: Professor, students: students) }
  let(:view_context) { double }
  let(:parent_builder) { double(ActionView::Helpers::FormBuilder, options: { url: 'parent_url' }) }
  subject do
    TestFormBuilder.new('professor', professor, view_context, url: 'form_url', parent_builder: parent_builder)
  end

  describe '#create_button' do
    before do
      allow(view_context)
        .to receive(:button_tag).with('+',
                                      name: 'professor[students_attributes][3][_create]',
                                      value: 1,
                                      formaction: 'form_url/#students',
                                      class: 'btn').and_return('markup')
    end

    it 'creates the appropriate markup' do
      expect(subject.create_button(:students, '+', class: 'btn'))
        .to eq('markup')
    end
  end

  describe '#destroy_button' do
    before do
      allow(view_context)
        .to receive(:button_tag).with('-',
                                      name: 'professor[_destroy]',
                                      value: 1,
                                      formaction: 'parent_url/#professors',
                                      class: 'btn').and_return('markup')
    end

    it 'creates the appropriate markup' do
      expect(subject.destroy_button('-', class: 'btn'))
        .to eq('markup')
    end
  end
end
