class ApiURL {
  //Base url
  // static final baseUrl = "https://a120-test.el.r.appspot.com/v2";
  static final baseUrl = "https://testapp.120army.com/v2";//todo url change
  // static final baseUrl = "https://app.120army.com/v2";

  //auth
  static final login = baseUrl + "/login";
  static final signUp = baseUrl + "/signup";
  static final forgotPwd = baseUrl + "/help";
  static final logout = baseUrl + "/logout";
  static final device = baseUrl + "/device";

  //Users
  static final profileUploadUrl = baseUrl + "/mediaUploadSignature";
  static final updateProfile = baseUrl + "/user";
  static final userDetail = baseUrl + "/user";
  static final updatePush = baseUrl + "/config";

  //Prayers
  static final getPrayerListing = baseUrl + "/posts";
  static final getUserPrayer = baseUrl + "/user";
  static final post = baseUrl + "/post";
  static final addComment = baseUrl + "/post";
  static final getComments = baseUrl + "/post";
  static final createNewPost = baseUrl + "/posts";
  static final prayAlong = baseUrl + "/post";
  //commment
  static final comment = baseUrl + "/comment";

  //Events
  static final getEventList = baseUrl + "/posts";

  //Groups
  static final createNewGroup = baseUrl + "/groups";
  static final addMembers = baseUrl + "/group";
  static final getGroups = baseUrl + "/groups";
  //users
  static final getUsers = baseUrl + "/users/search";

  //events
  static final getEvents = baseUrl + "/events";
  static final bookMarkEvent = baseUrl + "/event";

  //challenges
  static final fetchChallenges = baseUrl + "/dailyPrayer/categories";
  static final dailyPrayer = baseUrl + "/dailyPrayer";
  static final dailyPrayerGroupRequest = baseUrl + "/dailyPrayer/category";
  static final startChallenge = baseUrl + "/dailyPrayer";

  //patrons
  static final getPatrons = baseUrl + "/patrons";
  //notifications

  static final getNotifications = baseUrl + "/notifications";
  //dontions

  static final donation = baseUrl + "/donations";

  //stripe
   static final stripePublishableKey = "pk_test_rnf8eDNmvEF6ZCINktCqdXxV00HOWwuBmq";
   static final stripePublishableKeyLive = "pk_live_42y5Mdwitsykbo7vB1SRtBUC00zQgOTl0d";
   static final revnuekatKey = "vmdfAoWmtauCRiIlKBMFePtHRsoOzviM";//vmdfAoWmtauCRiIlKBMFePtHRsoOzviM
   static final purchaseKey = "cg_200_1m_droid";//vmdfAoWmtauCRiIlKBMFePtHRsoOzviM


  //Other Links

  static final privacyURL =
      "https://app.termly.io/document/privacy-policy/88252baa-baff-4b9e-90e9-e62029e0ecac";
  static final termsAndCondition =
      "https://app.termly.io/document/terms-of-use-for-website/0bd97d16-7b25-4d19-a4dc-caf56521df6c";


//  static let appLink: URL = "https://apps.apple.com/app/id1464419089"
//  static let stripePublishableKey: String = "pk_test_rnf8eDNmvEF6ZCINktCqdXxV00HOWwuBmq"
//  static let termsOfUseURL: URL = "https://app.termly.io/document/terms-of-use-for-website/0bd97d16-7b25-4d19-a4dc-caf56521df6c"
 // static let stripePublishableKey: String = "pk_test_rnf8eDNmvEF6ZCINktCqdXxV00HOWwuBmq"

}

