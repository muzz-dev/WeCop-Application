class Config
{
  static String ip="http://192.168.0.108/";
  static String base_url=ip+"PoilceProject/api/";

  //USER
  static String ADD_HOME = base_url+"addpreservehome.php";
  static String GET_FIRLIST = base_url+"getfirlistforuser.php";
  static String GET_FIRLOG = base_url+"getfirlogforuser.php";
  static String REGISTER_API = base_url+"register.php";
  static String READ_CRIME = base_url+"read_crime.php";
  static String CHANGEPASSWORD_API = base_url+"changepassword.php";
  static String UPDATE_REGISTER_STATUS = base_url+"updateregister.php";
  static String FORGOTPASSWORD_API = base_url+"forgotpassword.php";
  static String LOGIN_API = base_url+"login.php";
  static String GET_NUMBERS = base_url+"getEmerNumbers.php";
  static String GET_WANTEDDETAILS = base_url+"getwanteddetails.php";
  static String GET_MISSSINGPERSONDETAILS = base_url+"getmissingpersondetails.php";
  static String GET_MISSINGPERSON = base_url+"getmissingperson.php";
  static String GET_WANTEDPERSON = base_url+"getwanted.php";
  static String GET_VEHICLES = base_url+"getvehicles.php";
  static String GET_VEHICLESDETAILS = base_url+"getvehiclesdetails.php";
  static String GET_NEWS = base_url+"getnews.php";
  static String WOMEN_SAFETY = base_url+"womensafety.php";
  static String ADD_FEEDBACK = base_url+"addfeedback.php";
  static String GET_POLICESTATION = base_url+"getpolicestation.php";
  static String GET_POLICESTATION_DETAILS = base_url+"getpolicestationdetails.php";
  static String IMAGE_DEMO = base_url+"imagedemo.php";
  static String POLICESTATION_PATH= ip+"PoilceProject/admin/uploads/policestation/";
  static String MISSINGPERSON_PATH= ip+"PoilceProject/admin/uploads/missing/";
  static String VEHICLES_PATH= ip+"PoilceProject/admin/uploads/vehicles/";
  static String WANTED_PATH= ip+"PoilceProject/admin/uploads/wantedperson/";
  static String NEWS_PATH= ip+"PoilceProject/admin/uploads/news/";

  //Police
  static String POLICE_LOGIN_API = base_url + "loginpolice.php";
  static String ALLOCATED_FIR = base_url+"getallocatedfir.php";
  static String ALLOCATED_FIR_DETAILS = base_url+"getallocatedfirdetails";
  static String ALLOCATED_HOME = base_url+"getallocatedhome";
  static String READ_HOME = base_url + "read_preservehome.php";
  static String ALLOCATED_HOME_DETAILS = base_url+"getallocatedhomedetails";
  static String FORGOTPASSWORD_POLICE_API = base_url + "forgotpasswordpolice.php";
  static String CHANGEPASSWORD_POLICE_API = base_url + "changepasswordpolice.php";
}