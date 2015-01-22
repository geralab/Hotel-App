<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * 
 * @author Hussachai
 *
 */
class Service extends CI_Controller {
  
  public function __construct() {
    parent::__construct();
    $this->load->database();
  }
  
  public function authenticate(){
    $output = array();
    $username = $this->get_param('username');
    $password = $this->get_param('password');
    $sql = "SELECT * FROM green_users WHERE username=?";
    $query = $this->db->query($sql, array($username));
    $row = $query->row_array();
    if ($query->num_rows() > 0) {
      $this->load->library('encrypt');
      $key = config_item('encryption_key');
      $db_password = $this->encrypt->decode($row['password'], $key);
      if($db_password !== $password){
        $this->error('Incorrect password');
      }else{
        $output['token'] = md5(uniqid(rand(), true));
        unset($row['password']);
        unset($row['security_token']);
        $output['user'] = $row;
        $sql = "UPDATE green_users SET security_token=?, 
          modified_date=? WHERE username=?";
        $this->db->query($sql, array($output['token'], 
            date('Y-m-d H:i:s'), $username));
      }
    }else{
      $this->error('User not found');
    }
    
    $this->ok($output); 
  }
  
  public function storages(){
    $output = array();
    $token = $this->get_param('token');
    $this->check_role($token, array());//all roles
    $sql = "SELECT * FROM green_users WHERE security_token=?";
    $query = $this->db->query($sql, array($token));
    $hotel_id = $query->row()->hotel_id;
    if ($query->num_rows() == 1) {
      $sql = "SELECT * FROM green_storages WHERE hotel_id=?";
      $query = $this->db->query($sql, array($hotel_id));
      $output['storages'] = $query->result_array();
    }else if($query->num_rows() > 1){
      $this->error('Duplicated token. Try to re-authenticate.');
    }else{
      $this->error('Invalid token');
    }
    $this->ok($output);
  }
  
  public function item_types(){
    $output = array();
    $token = $this->get_param('token');
    $this->check_role($token, array());//all roles
    $sql = "SELECT * FROM green_item_types";
    $query = $this->db->query($sql, array());
    $output['item_types'] = $query->result_array();
    $this->ok($output);
  }
  
  public function stocks(){
    $output = array();
    $token = $this->get_param('token');
    $this->check_role($token, array());//all roles
    $storage_id = $this->get_param('storage_id');
    
    if($_SERVER['REQUEST_METHOD']=='POST'){
      $item_id = $this->get_param('item_id');
      $in_room = $this->get_param('in_room', false);
      $in_process = $this->get_param('in_process', false);
      $in_stock = $this->get_param('in_stock', false);
      $total_amount = $this->get_param('total_amount', false);
      
      $sql = "UPDATE green_stocks SET item_id=?";
      $params = array($item_id);
      if($in_room){
        $sql .= ",in_room=?";
        array_push($params, $in_room);
      }
      if($in_process){
        $sql .= ",in_process=?";
        array_push($params, $in_process);
      }
      if($in_stock){
        $sql .= ",in_stock=?";
        array_push($params, $in_stock);
      }
      if($total_amount){
        $sql .= ",total_amount=?";
        array_push($params, $total_amount);
      }
      $sql .= " WHERE storage_id = ? AND item_id = ?";
      array_push($params, $storage_id, $item_id);
      $query = $this->db->query($sql, $params);
      /*
      $in = $this->get_param('in');
      $op = $this->get_param('op');
      if(!in_array($in, array('room', 'process', 'total'))){
        $this->error("Invalid value for 'in' parameter. 
          It must be either 'room' or 'process'");
      } 
      if(!in_array($op, array('inc', 'dec'))){
        $this->error("Invalid value for 'op' parameter. 
          It must be either 'inc' or 'dec'");
      } 
      if($in == 'room'){
        if($op == 'inc'){
          $sql = "UPDATE green_stocks SET in_room=in_room+1, in_stock=in_stock-1";
        }else{
          $sql = "UPDATE green_stocks SET in_room=in_room-1, in_process=in_process+1";
        }
      }else if($in == 'process'){
        if($op == 'inc'){
          $sql = "UPDATE green_stocks SET in_process=in_process+1, in_stock=in_stock-1";
        }else{
          $sql = "UPDATE green_stocks SET in_process=in_room-1, in_stock=in_stock+1";
        }
      }else{
        if($op == 'inc'){
          $sql = "UPDATE green_stocks SET total_amount=total_amount+1, in_stock=in_stock+1";
        }else{
          $sql = "UPDATE green_stocks SET total_amount=total_amount-1, in_stock=in_stock-1";
        }
      }
       */
      
    }
    $sql = "SELECT s.item_id, i.name as item_name, it.id as item_type_id, it.name as item_type ,
      s.total_amount,s.in_stock, s.in_room, s.in_process FROM green_stocks s 
      INNER JOIN green_items i ON s.item_id = i.id 
      INNER JOIN green_item_types it ON i.type_id = it.id
      WHERE storage_id=?";
    $query = $this->db->query($sql, array($storage_id));
    $output['stocks'] = $query->result_array();
    $this->ok($output);
    
  }
  
  private function check_role($token, $roles = array()){
    $sql = "SELECT role FROM green_users WHERE security_token=?";
    $query = $this->db->query($sql, array($token));
    if($query->num_rows() === 0){
      $this->error('Invalid token');
    }else if($query->num_rows() > 1) {
      $this->error('Duplicated token. Try to re-authenticate.');
    }
    if(count($roles)===0) return;
    $role = $query->row()->role;
    if(!in_array($role, $roles)){
      $this->error('Insufficient priviledge');
    }
  }
  
  private function get_param($name, $required=true){
    $value = $this->input->get_post($name);
    if(!$value && $required) $this->error($name.' is missing');
    return $value;
  }
  
  private function error($message, $output = array()){
    $output['result'] = 'error';
    $output['message'] = $message;
    header('Content-Type: application/json');
    echo json_encode($output);
    die();
  }
  
  private function ok($output = array()){
    $output['result'] = 'ok';
    header('Content-Type: application/json');
    echo json_encode($output); 
  }
  
}
