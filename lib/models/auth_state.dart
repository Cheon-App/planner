/// The authentication status of the user.
enum AuthState {
  // The user profile is being loaded
  LOADING,
  // The user needs to log in
  UNAUTHENTICATED,
  // The user needs to accept a verification email
  UNVERIFIED,
  // The user is setting up their profile
  CONFIGURING,
  // The user is ready to go
  DONE,
}
