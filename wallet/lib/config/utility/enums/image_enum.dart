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
  signIn("sign_in"),
  signUp("sign_up_new"),
  amazonpay("amazonpay"),
  applepay("applepay"),
  googlepay("googlepay"),
  mastercard("mastercard"),
  netflex("netflex"),
  paypal("paypal"),
  stripe("stripe"),
  visa("visa"),





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
