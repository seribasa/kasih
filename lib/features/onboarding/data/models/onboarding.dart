class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getTitle() {
    return title;
  }

  String? getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = SliderModel();

  //1
  sliderModel.setDesc(
    "Selamat datang di Kasih, pendamping untuk mengatur perjalanan kesehatan Anda dan keluarga.",
  );
  sliderModel.setTitle("Selamat Datang");
  sliderModel.setImageAssetPath("assets/images/e_patient_logo.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
    "Mulai dari kebutuhan kesehatan Anda sendiri, lalu bantu keluarga sesuai akses yang mereka berikan.",
  );
  sliderModel.setTitle("Kesehatan Anda dan Keluarga");
  sliderModel.setImageAssetPath("assets/images/e_patient_care.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
