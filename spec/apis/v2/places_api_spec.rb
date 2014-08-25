require "spec_helper"

describe V2::PlacesApi do
  let(:places_path) { "/v2/places" }
  let(:place) { create :place }

  def favorited_places_path params={}
    str = "/v2/places/favorited"
    params[:before].nil? ? str : str + "?before=#{params[:before]}"
  end

  def favorite_place_path place_id
    "/v2/places/#{place_id}/favorite"
  end

  context "favorites" do
    it "list" do
      favorite = create :favorite_place, user: current_user, place: place
      res = auth_json_get favorited_places_path
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
      expect(res[:data].first[:favorite_id]).to eq(favorite.id)

      favorites = create_list :favorite_place, 2, user: current_user, place: place

      res = auth_json_get favorited_places_path
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(2)

      res = auth_json_get favorited_places_path(before: favorites.first.id)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end
  end

  context "favorite" do
    it "success" do
      res = auth_json_post favorite_place_path(place.id)
      expect(res[:place_id]).to eq(place.id)
      expect(res[:favorited]).to eq(true)
      expect(FavoritePlace.count).to eq(1)
      expect(FavoritePlace.first.user_id).to eq(current_user.id)
      expect(FavoritePlace.first.place_id).to eq(place.id)
    end

    it "success | return if already favorited" do
      create :favorite_place, user: current_user, place: place
      res = auth_json_post favorite_place_path(place.id)
      expect(res[:place_id]).to eq(place.id)
      expect(res[:favorited]).to eq(true)
      expect(FavoritePlace.count).to eq(1)
      expect(FavoritePlace.first.user_id).to eq(current_user.id)
      expect(FavoritePlace.first.place_id).to eq(place.id)
    end

    it "failed | invalid id" do
      res = auth_json_post favorite_place_path(-1)
      expect(res[:error]).to eq("Couldn't find Place with 'id'=-1")
    end
  end

  context "unfavorited" do
    it "success" do
      create :favorite_place, user: current_user, place: place
      expect(FavoritePlace.count).to eq(1)
      res = auth_json_delete favorite_place_path(place.id)
      expect(res[:place_id]).to eq(place.id)
      expect(res[:favorited]).to eq(false)
      expect(FavoritePlace.count).to eq(0)
    end
  end
end
