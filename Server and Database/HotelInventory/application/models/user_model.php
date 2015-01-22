<?php

if (!defined('BASEPATH'))
  exit('No direct script access allowed');

/**
 * 
 * @author Hussachai
 *
 */
class User_model extends CI_Model {

  public function __construct() {
    parent::__construct();
  }

  /**
   * 
   * @param type $email
   * @param type $password
   * @return mixed
   */
  public function authenticate($username, $password) {
    $sql = "SELECT * FROM green_users WHERE username=?";
    $query = $this->db->query($sql, array($username));
    $row = $query->row();
    if ($query->num_rows() > 0) {
      $this->load->library('encrypt');
      $key = config_item('encryption_key');
      $db_password = $this->encrypt->decode($row->password, $key);
      if($db_password === $password){
        return array(
          'id' => $row->id,
          'username' => $row->username,
          'email' => $row->email, 
          'role' => $row->role,
          'hotel_id' => $row->hotel_id);
      }
    }
    return false;
  }
  
  public function has_admin(){
    $sql = "SELECT COUNT(*) as total FROM green_users WHERE role=?";
    $query = $this->db->query($sql, array(ROLE_ADMIN));
    return $query->row()->total;
  }
  
  public function register($data){
    $sql = 'INSERT INTO green_users(username, password, email, 
        status, role, registered_date) VALUES(?, ?, ?, ?, ?, ?)';
    
    $hashed_passwd = $this->hash_passwd($data['password']);
    $status = $this->has_admin()?0: 1; 
    $params = array($data['email'], $hashed_passwd, $data['display_name'],
        $status, $data['role'], date('Y-m-d H:i:s'));
    $this->db->query($sql, $params);
    return $this->db->insert_id();
  }
  
  private function hash_passwd($passwd){
    return crypt($passwd, '$5$rounds=5678$C@nY0uGiveme_S@lt$');
  }
  
}
