require 'spec_helper'

describe "ReportPages" do
 
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in(user)
    Company.current_id = user.company.id
  end

  describe "show page" do
   
    context "for Next Irrigations" do
     
      before do
        visit report_path(:next_irrigations)
        Company.current_id = user.company.id
      end

      it { should have_selector 'title', text: full_title('Next Irrigations') }
      it { should have_selector 'h1', text: 'Irrigation Schedule' }

      context "with data" do
       
        let!(:irrigation) { FactoryGirl.create(:irrigation) }
        let(:current_irrigation) { irrigation.time.to_date.to_s(:long) }
        let(:next_irrigation) do
          et = Et.order("doy")
          kc = Kc.order("doy")
          current_et = CurrentEt.order("doy")
          irrigation.next_irrigation_date(et, kc, current_et).to_s(:long)
        end
 
        before { visit report_path(:next_irrigations) }

        it { should have_selector 'td', text: irrigation.field.name_with_block }
        it { should have_selector 'td', text: current_irrigation.squish }
        it { should have_selector 'td', text: next_irrigation.squish }
      end
    end
  end
end