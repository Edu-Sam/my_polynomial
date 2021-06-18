
class User{
  String username;
  String password;
  String polynomial;
  String derivative;

  User({this.username,this.password,this.polynomial,this.derivative});

  Map<String,dynamic> toJson()=>{
    'name':this.username,
    'password':this.password,
    'polynomial':this.polynomial,
    'derivative':this.derivative
  };

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      username: json['name'],
      password: json['password'],
      polynomial: json['polynomial'],
      derivative: json['derivative']
    );
  }
}