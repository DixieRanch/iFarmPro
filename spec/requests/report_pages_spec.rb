require 'rails_helper'

describe "ReportPages" do
  subject { page }

  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  context "for Next Irrigations" do
    before do
      visit report_path(:next_irrigations)
      Company.current_id = user.company.id
    end

    it "has correct elements" do
      expect(page).to have_title full_title('Schedule')
      expect(page).to have_selector 'h1', text: 'Irrigation Schedule'
    end

    context "with data" do
      let!(:irrigation) { create(:irrigation) }
      let(:current_irrigation) { irrigation.time.to_date.to_s(:long) }
      let(:next_irrigation) do
        et = Et.order("doy")
        kc = Kc.order("doy")
        current_et = CurrentEt.order("doy")
        irrigation.next_irrigation_date(et, kc, current_et).to_s(:long)
      end

      before { visit report_path(:next_irrigations) }

      it "displays irrigation report" do
        expect(page).to have_selector 'td',
                                      text: irrigation.field.name_with_block
        expect(page).to have_selector 'td', text: current_irrigation.squish
        expect(page).to have_selector 'td', text: next_irrigation.squish
      end
    end
  end

  context "for Fertilizer" do
    before do
      visit report_path(:fertilizer)
    end

    it "has correct elements" do
      expect(page).to have_title full_title('Nutrition')
      expect(page).to have_selector 'h1', text: 'Nutrition Report'
    end

    context "with data" do
      before do
        Company.current_id = user.company.id
        @app = create(:soil_application, quantity: 150,
                                         field: create(:field, name: 'new', acreage: 7))
        visit report_path(:fertilizer)
        # save_and_open_page
        Company.current_id = user.company.id
      end

      it "displays fertilizer report" do
        expect(page).to have_selector 'td', text: @app.field.name_with_block
        expect(page).to have_selector 'td', text: (150 * 11 * 0.16 / 7).round.to_s
        expect(page).to have_selector 'td', text: (150 * 11 * 0.08 / 7).round.to_s
        expect(page).to have_selector 'td', text: (150 * 11 * 0.03 / 7).round.to_s
        expect(page).to have_selector 'td', text: (150 * 11 * 0.04 / 7).round.to_s
      end
    end
  end
end
