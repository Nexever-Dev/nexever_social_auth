/// A class representing Facebook account data.
class FacebookAccountData {
  String? name;
  Picture? picture;
  String? firstName;
  String? lastName;
  String? email;
  String? id;

  /// Constructs a [FacebookAccountData] instance with optional fields.
  FacebookAccountData({
    this.name,
    this.picture,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  /// Creates a [FacebookAccountData] instance from a JSON object.
  FacebookAccountData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    picture =
        json['picture'] != null ? Picture.fromJson(json['picture']) : null;
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    id = json['id'];
  }

  /// Converts a [FacebookAccountData] instance to a JSON object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (picture != null) {
      data['picture'] = picture!.toJson();
    }
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}

/// A class representing a picture in Facebook account data.
class Picture {
  Data? data;

  /// Constructs a [Picture] instance with optional [data].
  Picture({this.data});

  /// Creates a [Picture] instance from a JSON object.
  Picture.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  /// Converts a [Picture] instance to a JSON object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

/// A class representing the data of a picture in Facebook account data.
class Data {
  int? height;
  bool? isSilhouette;
  String? url;
  int? width;

  /// Constructs a [Data] instance with optional fields.
  Data({this.height, this.isSilhouette, this.url, this.width});

  /// Creates a [Data] instance from a JSON object.
  Data.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    isSilhouette = json['is_silhouette'];
    url = json['url'];
    width = json['width'];
  }

  /// Converts a [Data] instance to a JSON object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['is_silhouette'] = isSilhouette;
    data['url'] = url;
    data['width'] = width;
    return data;
  }
}
