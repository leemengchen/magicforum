require 'rails_helper'

 RSpec.describe StaticPagesController, type: :controller do

   describe "about" do
     it "should render about" do

       get :about
       expect(subject).to render_template(:about)
     end
   end
 end
