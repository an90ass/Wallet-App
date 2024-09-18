enum ImageEnum {
  profile("profile"),
  keySquare("key_square"),
  eye("eye"),
  eyeSlash("eye_slash"),
  email("email"),
  chart("chart"),
  notification("notification"),
  payment("payment"),
  payout("payout"),
  settings("settings"),
  topup("topup"),
  transfer("transfer"),
  wallet("wallet"),

  // Add new image enum here
  horizontalCard("horizontal_card"),
  verticalCard("vertical_card"),
  profilePicture("profile_picture"),
  ;

  final String value;

  const ImageEnum(this.value);

  String get svgPath => "assets/svg/$value.svg";
  String get imagePath => "assets/images/$value.png";
}
