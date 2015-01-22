<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * 
 * @author Hussachai
 *
 */
class Auth_manager extends CI_Controller {

  public function __construct() {
    parent::__construct();
    $this->load->model('user_model', null, true);
  }
  
  public function index() {
    $data = array();
    if(Auth::is_auth()){
      redirect('/manager/hotels');
    }else{
      $this->load->view('login', $data);
    }
  }
  
  public function login() {
    $this->form_validation->set_rules('username', 'Username', 'required');
    $this->form_validation->set_rules('password', 'Password', 'required');
    $data = array();
    if ($this->form_validation->run() === false) {
      $data['error'] = 'Username and password are required';
    } else {
      $user = $this->user_model->authenticate($this->input->post('username'), $this->input->post('password'));
      if ($user) {
        if(in_array($user['role'], array(ROLE_ADMIN, ROLE_MANAGER))){
          Auth::set_auth($user);
        }else{
          $data['error'] = 'Not enough priviledge';
        }
      } else {
        $data['error'] = 'Invalid email/password combination';
      }
    }
    if(Auth::is_auth()){
      redirect('/manager/hotels');
    }else{
      $this->load->view('login', $data);
    }
  }
  
  public function logout() {

    $this->session->sess_destroy();
    session_destroy();
    redirect('/auth_manager');
  }
  
}
