RSpec.shared_examples 'a tenant model' do
  it "has only the current company's data" do
    set_tenant_company
    other_companys_data = create subject.class.name.underscore.to_sym

    set_tenant_company
    this_companys_data = create subject.class.name.underscore.to_sym

    expect(subject.class.all).to include this_companys_data
    expect(subject.class.all).not_to include other_companys_data
  end
end
