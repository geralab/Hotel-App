<?php

if (!defined('BASEPATH'))
  exit('No direct script access allowed');

/**
 * 
 * @author Hussachai
 *
 */
class App_hooks {

  private $CI;
  private $public_actions;

  //--------------------------------------------------------------------

  public function __construct() {
    $this->CI = & get_instance();

    $this->public_actions = config_item('auth_public_actions');
    $this->public_actions['auth_manager'] = '*';
  }

  //--------------------------------------------------------------------

  public function is_public_action() {

    $class_name = $this->CI->router->class;
    $method_name = $this->CI->router->method;
    
    if (array_key_exists($class_name, $this->public_actions)) {
      $allowed_methods = $this->public_actions[$class_name];
      if (is_array($allowed_methods)) {
        if (count($allowed_methods) === 1) {
          if($allowed_methods[0] === '*') return true;
          if($allowed_methods[0] === $method_name) return true;
        } else if (array_search($method_name, $allowed_methods)) {
          return true;
        }
      } else if ($allowed_methods === '*') {
        return true;
      }
    }
    return false;
  }

  public function check_auth() {

    $this->CI->load->helper('url');

    if ($this->is_public_action()) {
      return;
    }

    if (!Auth::is_auth()) {
      redirect('/auth_manager/login', 'location'); //location/refresh
    }
  }

  /**
   * Stores the name of the current uri in the session as 'previous_page'.
   * This allows redirects to take us back to the previous page without
   * relying on inconsistent browser support or spoofing.
   * 
   * @access	public
   * @return	void
   */
  public function save_requested() {

    $class_name = $this->CI->router->class;

    if ($class_name === 'auth_manager') {
      return;
    }
    
    if (!class_exists('CI_Session')) {
      $this->ci->load->library('session');
    }

    if (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
      //ajax
    } else {
      if ($_SERVER['REQUEST_METHOD'] === 'GET') {
          $this->CI->session->set_userdata('_last_page', current_url());
      }
    }
  }
  
}

class Nav {
  
  public static function last_page($default='/'){
    $CI = & get_instance();
    $last_page = $CI->session->userdata('_last_page');
    if($last_page != current_url()) return $last_page;
    return $default;
  }
  
}


const ROLE_ADMIN = 'ADMIN';
const ROLE_MANAGER = 'MANAGER';
const ROLE_HOUSEKEEPER = 'HOUSEKEEPER';

class Auth {
    
  const AUTH_KEY = '_auth';
  
  public static function is_auth() {
    $CI = & get_instance();
    return $CI->session->userdata(Auth::AUTH_KEY) == true;
  }

  public static function has_roles($roles) {
    if(!self::is_auth()) return false;
    $user_role = self::user_attr('role');
    if(is_array($roles)){
      return is_int(array_search($user_role, $roles));
    }else if(is_string($roles)){
      return $user_role === $roles;
    }
    return false;
  }
  
  public static function set_auth($user) {
    $CI = & get_instance();
    return $CI->session->set_userdata(Auth::AUTH_KEY, serialize($user));
  }

  public static function unset_auth() {
    $CI = & get_instance();
    return $CI->session->unset_userdata(Auth::AUTH_KEY);
  }
  
  public static function user_attr($attr_name) {
    $CI = & get_instance();
    $data = $CI->session->userdata(Auth::AUTH_KEY);
    if($data) {
      $user = unserialize($data);
      if(array_key_exists($attr_name, $user)){
        return $user[$attr_name];
      }
    }
    return false;
  }
  
}

// End App_hooks class
