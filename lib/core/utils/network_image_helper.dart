String networkImage(String? image) {
  if (image == null || image == '') {
    return 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';
  } else {
    return image;
  }
}
