import 'dart:convert';

class LoginForm {
  String? once;
  String? accKey;
  String? pwdKey;
  String? codeKey;
  String? code;
  String? img;

  LoginForm({
    this.once,
    this.accKey,
    this.pwdKey,
    this.codeKey,
    this.code,
    this.img,
  });

  factory LoginForm.fromRawJson(String str) => LoginForm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginForm.fromJson(Map<String, dynamic> json) =>
      LoginForm(
        once: json["once"],
        accKey: json["accKey"],
        pwdKey: json["pwdKey"],
        codeKey: json["codeKey"],
        code: json["code"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() =>
      {
        "once": once,
        "accKey": accKey,
        "pwdKey": pwdKey,
        "codeKey": codeKey,
        "code": code,
        "img": img,
      };

  String toString() => jsonEncode(this.toJson());
}
