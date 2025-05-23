
class ApiConstant {

  static const String baseUri = "https://next-crib-backend.onrender.com/api/";

  static const String getSCountryApi = baseUri + 'location/countries';

  static const String getStateApi = baseUri + 'location/states/NG';

  static const String agentSignUpApi = baseUri + 'agents/signup';

  static const String customerSignUpApi = baseUri + 'customers/signup';

  static const String agentEmailVerification = baseUri + 'agents/verify-email';

  static const String customerEmailVerification = baseUri + 'customers/verify-email';

  static const String agentLogInApi = baseUri + 'agents/login';

  static const String customerLogInApi = baseUri + 'customers/login';

  static const String customerForgetPassword = baseUri + 'customers/forgot-password';

  static const String agentForgetPassword = baseUri + 'agents/forgot-password';

  static const String customerValidateOtp = baseUri + 'customers/validate-otp';

  static const String agentValidateOtp = baseUri + 'agents/validate-otp';

  static const String customerResetPassword = baseUri + 'customers/reset-password';

  static const String agentResetPassword = baseUri + 'agents/reset-password';

  static const String getAllProperties = baseUri + 'properties';

  static const String getRecentProperties = baseUri + 'properties/latest';

  static const String editAgentProfile = baseUri + 'agents/update-me';

  static const String editCustomerProfile = baseUri + 'customers/update-me';

  static const String createProperty = baseUri + 'properties';


}