/// Static string constants used throughout the CampusKart app.
abstract final class AppStrings {
  // ── App identity ─────────────────────────────────────────────────────────
  static const String appName = 'CampusKart';
  static const String appTagline = 'The campus marketplace';
  static const String appSubTagline =
      'Find useful things nearby. Trade simply. Keep your number private.';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String login = 'Log in';
  static const String register = 'Create account';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm password';
  static const String displayName = 'Display name';
  static const String forgotPassword = 'Forgot password?';
  static const String noAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signOut = 'Sign out';
  static const String campusEmailHint =
      'Use your college email (e.g. you@college.edu)';

  // ── Listings ─────────────────────────────────────────────────────────────
  static const String listings = 'Listings';
  static const String createListing = 'Create listing';
  static const String sellAnItem = 'Sell an item';
  static const String listSomethingUseful = 'List something useful';
  static const String itemTitle = 'Item title';
  static const String priceInr = 'Price (₹)';
  static const String description = 'Description';
  static const String condition = 'Condition';
  static const String category = 'Category';
  static const String photos = 'Photos';
  static const String publishListing = 'Publish listing';
  static const String enhanceWithAi = 'Enhance with AI';
  static const String markAsSold = 'Mark as sold';
  static const String deleteListing = 'Delete listing';
  static const String searchHint = 'Search books, kits, calculators…';
  static const String comingSoon = 'Coming Soon';

  // ── Categories ───────────────────────────────────────────────────────────
  static const String categoryAll = 'All';
  static const String categoryBooks = 'Books';
  static const String categoryElectronics = 'Electronics';
  static const String categoryLabGear = 'Lab Gear';
  static const String categoryFurniture = 'Furniture';
  static const String categoryClothing = 'Clothing';
  static const String categoryOther = 'Other';

  static const List<String> categories = [
    categoryAll,
    categoryBooks,
    categoryElectronics,
    categoryLabGear,
    categoryFurniture,
    categoryClothing,
    categoryOther,
  ];

  // ── Condition labels ─────────────────────────────────────────────────────
  static const String conditionNew = 'New';
  static const String conditionLikeNew = 'Like New';
  static const String conditionGood = 'Good';
  static const String conditionFair = 'Fair';

  // ── Chat ─────────────────────────────────────────────────────────────────
  static const String messages = 'Messages';
  static const String inbox = 'Inbox';
  static const String messageSeller = 'Message seller';
  static const String typeAMessage = 'Write a message…';
  static const String smartReplies = 'Smart replies';
  static const String noMessages = 'No messages yet.';
  static const String noChats = 'No conversations yet.';

  // ── Profile ──────────────────────────────────────────────────────────────
  static const String profile = 'Profile';
  static const String myListings = 'My listings';
  static const String campusLocation = 'Campus location';
  static const String joined = 'Joined';
  static const String editProfile = 'Edit profile';

  // ── Generic ──────────────────────────────────────────────────────────────
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String loading = 'Loading…';
  static const String retry = 'Retry';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String noResultsFound = 'No results found.';
}
