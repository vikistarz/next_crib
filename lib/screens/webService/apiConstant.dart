
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

  static const String getAllProperties = baseUri + 'properties';


}