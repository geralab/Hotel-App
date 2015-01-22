<?php

if (!defined('BASEPATH'))
  exit('No direct script access allowed');

class Manager extends CI_Controller {

  public function __construct() {
    parent::__construct();
    
    $this->load->database();
    $this->load->helper('url');

    $this->load->library('grocery_CRUD');
  }
  
  public function _default_output($output = null) {
    $this->load->view('manager.php',$output);
  }
    
  public function users() {
    if(!Auth::has_roles(ROLE_ADMIN)){
      die('Not enough priviledge');
    }
    try {
      $crud = new grocery_CRUD();
      $crud->set_theme('datatables');
      $crud->set_table('green_users');
      $crud->set_relation('hotel_id', 'green_hotels', 'name');
      $crud->display_as('hotel_id','Hotel');
      $crud->set_subject('Users');
      $crud->required_fields('hotel_id','username', 'password', 'email', 'role');
      $crud->columns('hotel_id', 'first_name', 'last_name', 'username', 'email', 'role');
      $crud->field_type('role','dropdown', array(
          ROLE_ADMIN => 'Administrator', ROLE_MANAGER => 'Manager', 
          ROLE_HOUSEKEEPER => 'House Keeper'));
      $crud->field_type('password', 'password');
      $crud->callback_before_insert(array($this,'encrypt_password_callback'));
      $crud->callback_before_update(array($this,'encrypt_password_callback'));
      $crud->callback_edit_field('password',array($this,'decrypt_password_callback'));
      
      $output = $crud->render();
      $_GET['title'] = 'Users';
      $this->_default_output($output);
    } catch (Exception $e) {
      show_error($e->getMessage() . ' --- ' . $e->getTraceAsString());
    }
  }
  
  function encrypt_password_callback($post_array, $primary_key = null){
    $this->load->library('encrypt');
    $key = config_item('encryption_key');
    $post_array['password'] = $this->encrypt->encode($post_array['password'], $key);
    return $post_array;
  }
 
  function decrypt_password_callback($value){
    $this->load->library('encrypt');
    $key = config_item('encryption_key');
    $decrypted_password = $this->encrypt->decode($value, $key);
    return "<input type='password' name='password' value='$decrypted_password' />";
  }
  
  public function hotels() {
    try {
      $crud = new grocery_CRUD();
      $crud->set_theme('datatables');
      $crud->set_table('green_hotels');
      $crud->set_subject('Hotels');
      $crud->required_fields('name');
      $crud->columns('id','name', 'address', 'city', 'state', 'zip');
      if(!Auth::has_roles(ROLE_ADMIN)){
        $hotel_id = Auth::user_attr('hotel_id');
        $crud->where('id', $hotel_id);
      }
      $output = $crud->render();
      $_GET['title'] = 'Hotels';
      $this->_default_output($output);
    } catch (Exception $e) {
      show_error($e->getMessage() . ' --- ' . $e->getTraceAsString());
    }
  }
  
  public function storages() {
    try {
      $crud = new grocery_CRUD();
      $crud->set_theme('datatables');
      $crud->set_table('green_storages');
      $crud->set_relation('hotel_id', 'green_hotels', 'name');
      $crud->display_as('hotel_id','Hotel');
      $crud->set_subject('Storages');
      $crud->required_fields('hotel_id', 'name');
      $crud->columns('id','hotel_id', 'name', 'floor');
      if(!Auth::has_roles(ROLE_ADMIN)){
        $hotel_id = Auth::user_attr('hotel_id');
        $crud->where('hotel_id', $hotel_id);
      }
      $output = $crud->render();
      $_GET['title'] = 'Storages';
      $this->_default_output($output);
    } catch (Exception $e) {
      show_error($e->getMessage() . ' --- ' . $e->getTraceAsString());
    }
  }
  
  public function item_types() {
    try {
      $crud = new grocery_CRUD();
      $crud->set_theme('datatables');
      $crud->set_table('green_item_types');
      $crud->set_subject('Item Types');
      $crud->required_fields('name');
      $crud->columns('id', 'name');
      $output = $crud->render();
      $_GET['title'] = 'Item Types';
      $this->_default_output($output);
    } catch (Exception $e) {
      show_error($e->getMessage() . ' --- ' . $e->getTraceAsString());
    }
  }
  
  public function items() {
    try {
      $crud = new grocery_CRUD();
      $crud->set_theme('datatables');
      $crud->set_table('green_items');
      $crud->set_relation('type_id', 'green_item_types', 'name');
      $crud->display_as('type_id','Type');
      $crud->set_subject('Items');
      $crud->required_fields('type_id', 'name');
      $crud->columns('type_id', 'name', 'description');
      $output = $crud->render();
      $_GET['title'] = 'Items';
      $this->_default_output($output);
    } catch (Exception $e) {
      show_error($e->getMessage() . ' --- ' . $e->getTraceAsString());
    }
  }
  
  public function stocks() {
    try {
      $crud = new grocery_CRUD();
      $crud->set_theme('datatables');
      $crud->set_table('green_stocks');
      $crud->set_relation('storage_id', 'green_storages', 'name');
      $crud->display_as('storage_id','Storage');
      $crud->set_relation('item_id', 'green_items', 'name');
      $crud->display_as('item_id','Item');
      $crud->set_subject('Stocks');
      $crud->required_fields('storage_id', 'item_id');
      $crud->columns('storage_id', 'item_id', 'total_amount', 
              'in_stock', 'in_room', 'in_process');
//      if(!Auth::has_roles(ROLE_ADMIN)){
//        $hotel_id = Auth::user_attr('hotel_id');
//        $sql = "SELECT * FROM green_storages WHERE hotel_id=?";
//        $query = $this->db->query($sql, array($hotel_id));
//        $first_where = false;
//        foreach($query->result() as $row){
//          if(!$first_where){
//            $crud->where('storage_id', $row->id);
//            $first_where = true;
//          }else{
//            $crud->or_where('storage_id', $row->id);
//          }
//        }
//      }
      $output = $crud->render();
      $_GET['title'] = 'Stocks';
      $this->_default_output($output);
    } catch (Exception $e) {
      show_error($e->getMessage() . ' --- ' . $e->getTraceAsString());
    }
  }
}
