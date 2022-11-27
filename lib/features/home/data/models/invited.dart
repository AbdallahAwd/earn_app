class InvitedPeople {
  final String name;
  final String avatar;

  InvitedPeople(this.name, this.avatar);
  factory InvitedPeople.fromJson(Map<String, dynamic> json) =>
      InvitedPeople(json['name'], json['avatar']);
  Map<String, dynamic> toJson() => {
        'name': name,
        'avatar': avatar,
      };
}
