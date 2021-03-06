// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// HydroFlask NOTES:
// do NOT add //=require_tree .   (messes up rails_admin)
// products.js is required manually on only the products/show page
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require ckeditor/init
//= require fancybox/jquery.fancybox
//= require raty/jquery.raty.min
//= require jqzoom/jquery.jqzoom-core
//= require builder
//= require carts
//= require categories
//= require orders
//= require pages
//= require socials
//= require site

$j = jQuery.noConflict();

$j.fn.preload = function() {
    this.each(function(){
        $j('<img/>')[0].src = this;
    });
}