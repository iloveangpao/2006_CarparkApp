class Carpark {
  final String typeOfCarpark;
  final String address;
  final int availableLots;
  final double pricePerHours;
  final String imageUrl;
  final double distInKm;

  const Carpark({
    required this.typeOfCarpark,
    required this.address,
    required this.availableLots,
    required this.pricePerHours,
    required this.distInKm,
    required this.imageUrl,
  });
}

const carparkList = [
  Carpark(
      typeOfCarpark: "Multistorey",
      address: "267 Boon Lay Dr, Singapore 641167",
      availableLots: 450,
      pricePerHours: 1.5,
      distInKm: 0.2,
      imageUrl:
          "https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=t93o-l6ukHAPuL7KnL7bKg&cb_client=search.gws-prod.gps&w=408&h=240&yaw=195.40887&pitch=0&thumbfov=100"),
  Carpark(
      typeOfCarpark: "Multistorey",
      address: "267 Boon Lay Dr, Singapore 641167",
      availableLots: 350,
      pricePerHours: 3.5,
      distInKm: 0.8,
      imageUrl:
          "https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=T0LkSJUMyfaDQhnHup1avQ&cb_client=search.gws-prod.gps&w=408&h=240&yaw=308.83386&pitch=0&thumbfov=100"),
  Carpark(
      typeOfCarpark: "Roadside",
      address: "267 Pioneer Dr, Singapore 648167",
      availableLots: 450,
      pricePerHours: 2.5,
      distInKm: 1.4,
      imageUrl:
          "https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=t93o-l6ukHAPuL7KnL7bKg&cb_client=search.gws-prod.gps&w=408&h=240&yaw=195.40887&pitch=0&thumbfov=100"),
  Carpark(
      typeOfCarpark: "Roadside",
      address: "267 Boon Lay Dr, Singapore 641167",
      availableLots: 200,
      pricePerHours: 1.5,
      distInKm: 3,
      imageUrl:
          "https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=T0LkSJUMyfaDQhnHup1avQ&cb_client=search.gws-prod.gps&w=408&h=240&yaw=308.83386&pitch=0&thumbfov=100"),
  Carpark(
      typeOfCarpark: "Multistorey",
      address: "267 Ang Mo Kio Dr, Singapore 641167",
      availableLots: 80,
      pricePerHours: 1,
      distInKm: 2.6,
      imageUrl:
          "https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=t93o-l6ukHAPuL7KnL7bKg&cb_client=search.gws-prod.gps&w=408&h=240&yaw=195.40887&pitch=0&thumbfov=100"),
  Carpark(
      typeOfCarpark: "Multistorey",
      address: "267 Boon Lay Dr, Singapore 641167",
      availableLots: 450,
      pricePerHours: 1.5,
      distInKm: 4.8,
      imageUrl:
          "https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=T0LkSJUMyfaDQhnHup1avQ&cb_client=search.gws-prod.gps&w=408&h=240&yaw=308.83386&pitch=0&thumbfov=100"),
];
