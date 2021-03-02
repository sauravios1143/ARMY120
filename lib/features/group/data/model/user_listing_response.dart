class UserListingResponse {
  List<SystemUser> hits;
  int nbHits;
  int page;
  int nbPages;
  int hitsPerPage;
  bool exhaustiveNbHits;
  String query;
  String params;
  int processingTimeMS;

  UserListingResponse(
      {this.hits,
        this.nbHits,
        this.page,
        this.nbPages,
        this.hitsPerPage,
        this.exhaustiveNbHits,
        this.query,
        this.params,
        this.processingTimeMS});

  UserListingResponse.fromJson(Map<String, dynamic> json) {
    if (json['hits'] != null) {
      hits = new List<SystemUser>();
      json['hits'].forEach((v) {
        hits.add(new SystemUser.fromJson(v));
      });
    }
    nbHits = json['nbHits'];
    page = json['page'];
    nbPages = json['nbPages'];
    hitsPerPage = json['hitsPerPage'];
    exhaustiveNbHits = json['exhaustiveNbHits'];
    query = json['query'];
    params = json['params'];
    processingTimeMS = json['processingTimeMS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hits != null) {
      data['hits'] = this.hits.map((v) => v.toJson()).toList();
    }
    data['nbHits'] = this.nbHits;
    data['page'] = this.page;
    data['nbPages'] = this.nbPages;
    data['hitsPerPage'] = this.hitsPerPage;
    data['exhaustiveNbHits'] = this.exhaustiveNbHits;
    data['query'] = this.query;
    data['params'] = this.params;
    data['processingTimeMS'] = this.processingTimeMS;
    return data;
  }
}

class SystemUser {
  String name;
  String username;
  String email;
  String objectID;
  HighlightResult hHighlightResult;

  SystemUser(
      {this.name,
        this.username,
        this.email,
        this.objectID,
        this.hHighlightResult});

  SystemUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    objectID = json['objectID'];
    hHighlightResult = json['_highlightResult'] != null
        ? new HighlightResult.fromJson(json['_highlightResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['objectID'] = this.objectID;
    if (this.hHighlightResult != null) {
      data['_highlightResult'] = this.hHighlightResult.toJson();
    }
    return data;
  }
}

class HighlightResult {
  Username username;
  Username email;

  HighlightResult({this.username, this.email});

  HighlightResult.fromJson(Map<String, dynamic> json) {
    username = json['username'] != null
        ? new Username.fromJson(json['username'])
        : null;
    email = json['email'] != null ? new Username.fromJson(json['email']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.username != null) {
      data['username'] = this.username.toJson();
    }
    if (this.email != null) {
      data['email'] = this.email.toJson();
    }
    return data;
  }
}

class Username {
  String value;
  String matchLevel;
  bool fullyHighlighted;
  List<String> matchedWords;

  Username(
      {this.value, this.matchLevel, this.fullyHighlighted, this.matchedWords});

  Username.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    matchLevel = json['matchLevel'];
    fullyHighlighted = json['fullyHighlighted'];
    matchedWords = json['matchedWords'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['matchLevel'] = this.matchLevel;
    data['fullyHighlighted'] = this.fullyHighlighted;
    data['matchedWords'] = this.matchedWords;
    return data;
  }
}