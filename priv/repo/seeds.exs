alias HelpingHand.Repo
alias HelpingHand.Schema.NgoDetails
alias HelpingHand.Schema.FoodItems
alias HelpingHand.Schema.Restaurants

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HelpingHand.Repo.insert!(%HelpingHand.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Repo.insert(%NgoDetails{
  name: "Feeding India",
  password: "feeding@india",
  address: "564 Shivalik Vihar Chandigarh 133301",
  email: "feedingindiaproj@gmail.com",
  contact: "9871178810"
})

Repo.insert(%NgoDetails{
  name: "Hunger Hero",
  password: "hunger@hero",
  address: "SCO 1100 Sector 22b Chandigarh 160017",
  email: "hungerhero@gmail.com",
  contact: "9986438450"
})

res1 =
  Repo.insert!(%Restaurants{
    name: "Anupam Sweets",
    address: "SCO : 69, Sector 11, Panchkula",
    email: "skashyap@watermarkinsights.com",
    contact: "9038878421"
  })

res2 =
  Repo.insert!(%Restaurants{
    name: "Qizo",
    address: "SCO : 74, Sector 26, Chandigarh",
    email: "skasyap@watermarkinsights.com",
    contact: "9038878434"
  })

res3 =
  Repo.insert!(%Restaurants{
    name: "Shangz",
    address: "SCO : 5, Sector 8, Panchkula",
    email: "skashyap@watermarkinsights.com",
    contact: "9038878489"
  })

res4 =
  Repo.insert!(%Restaurants{
    name: "Dastaan",
    address: "SCO : 51, Sector 8, Panchkula",
    email: "skashyap@watermarkinsights.com",
    contact: "9038878473"
  })

res5 =
  Repo.insert!(%Restaurants{
    name: "Lazy Shack",
    address: "SCO : 79, Sector 26, Chandigarh",
    email: "skashyap@watermarkinsights.com",
    contact: "9038878456"
  })

res6 =
  Repo.insert!(%Restaurants{
    name: "Sanjha Chulha",
    address: "SCO : 90, Sector 26, Chandigarh",
    email: "skashyap@watermarkinsights.com",
    contact: "9038878531"
  })

Repo.insert!(%FoodItems{
  item: "Tawa Roti",
  quantity: "20",
  restaurant_id: Map.get(res1, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Tawa Roti",
  quantity: "30",
  restaurant_id: Map.get(res2, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Tawa Roti",
  quantity: "40",
  restaurant_id: Map.get(res3, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Biryani",
  quantity: "1 kg",
  restaurant_id: Map.get(res1, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Biryani",
  quantity: "500 g",
  restaurant_id: Map.get(res2, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Biryani",
  quantity: "2 kg",
  restaurant_id: Map.get(res3, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Noodles",
  quantity: "500 gms",
  restaurant_id: Map.get(res1, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Noodles",
  quantity: "1 kg",
  restaurant_id: Map.get(res3, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Noodles",
  quantity: "500 gms",
  restaurant_id: Map.get(res4, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Kadhai Panner",
  quantity: "500 gms",
  restaurant_id: Map.get(res4, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Rajma Chawal",
  quantity: "500 gms",
  restaurant_id: Map.get(res5, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Dal Makhani",
  quantity: "500 gms",
  restaurant_id: Map.get(res5, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Moong dal ka halwa",
  quantity: "500 gms",
  restaurant_id: Map.get(res3, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Gajar ka halwa",
  quantity: "500 gms",
  restaurant_id: Map.get(res3, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Mix Veg Pulao",
  quantity: "500 gms",
  restaurant_id: Map.get(res3, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Saag",
  quantity: "1 kg",
  restaurant_id: Map.get(res6, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Maki di roti",
  quantity: "20",
  restaurant_id: Map.get(res6, :uuid)
})

Repo.insert!(%FoodItems{
  item: "Lassi",
  quantity: "5 Ltr",
  restaurant_id: Map.get(res6, :uuid)
})
