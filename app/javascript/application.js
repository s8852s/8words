// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require jquery_ujs
//= require bootstrap
import "@hotwired/turbo-rails"
import "controllers"
import './add_jquery'
import './generate_8words'
import "trix"
import "@rails/actiontext"
import jquery from "jquery"
window.$ = jquery
window.jQuery = jquery

$(document).ready(function() {
  console.log(111)
});
