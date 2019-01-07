/*-
 * Copyright (c) 2017-2018 Subhadeep Jasu <subhajasu@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 *
 * Authored by: Subhadeep Jasu <subhajasu@gmail.com>
 *              Saunak Biswas  <saunakbis97@gmail.com>
 */

namespace Pebbles {
    public class DateView : Gtk.Grid {
        // Make Date Calculation Mode Switcher
        Granite.Widgets.ModeButton date_mode;
        
        // Make Date Difference View
        Gtk.Grid date_difference_view;
        Granite.Widgets.DatePicker datepicker_diff_from;
        DateTime datetime_diff_from;
        Granite.Widgets.DatePicker datepicker_diff_to;
        DateTime datetime_diff_to;
        Gtk.Label date_diff_label;
        Gtk.Label days_diff_label;
        
        // Make Add Date View
        Gtk.Grid date_add_view;
        Granite.Widgets.DatePicker datepicker_add_sub;
        Gtk.Label week_day_label;
        Gtk.Label date_dmy_label;
        
        // Header Bar Controls
        Gtk.Stack date_mode_stack;
        Gtk.Switch diff_mode_switch;
        Gtk.Switch add_mode_switch;
        
        Gtk.Grid date_diff_grid;
        Gtk.Grid date_add_grid;
        
        DateCalculator date_calculator_object;
        construct {
            build_ui ();
        }
        
        public DateView (MainWindow window) {
            this.diff_mode_switch = window.diff_mode_switch;
            this.add_mode_switch = window.add_mode_switch;
            this.date_mode_stack = window.date_mode_stack;
            this.date_diff_grid = window.date_diff_grid;
            this.date_add_grid = window.date_add_grid;
        }
        
        private void build_ui () {
            // Make Date Mode Switcher ////////////////////////////////////////////////////
            date_mode = new Granite.Widgets.ModeButton ();
            date_mode.append_text ("Difference Between Dates");
            date_mode.append_text ("Add or Subtract Dates");
            date_mode.margin_start = 100;
            date_mode.margin_end = 100;
            
            // Make Date Difference View
            // ---------------------------------------------------------------------------
            date_difference_view = new Gtk.Grid ();
            var from_label = new Gtk.Label ("From");
            from_label.xalign = 0;
            from_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            datepicker_diff_from = new Granite.Widgets.DatePicker ();
            var to_label  = new Gtk.Label ("To");
            to_label.margin_top = 4;
            to_label.xalign = 0;
            to_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            datepicker_diff_to   = new Granite.Widgets.DatePicker ();
            date_difference_view.attach (from_label, 0, 0, 1, 1);
            date_difference_view.attach (datepicker_diff_from, 0, 1, 1, 1);
            date_difference_view.attach (to_label, 0, 2, 1, 1);
            date_difference_view.attach (datepicker_diff_to, 0, 3, 1, 1);
            
            var diff_header = new Gtk.Label ("Difference");
            diff_header.xalign = 0;
            diff_header.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            
            date_diff_label = new Gtk.Label ("Hey, it's the same date \n ");
            date_diff_label.xalign = 0;
            date_diff_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
            days_diff_label = new Gtk.Label ("");
            days_diff_label.xalign = 0;
            days_diff_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            var diff_grid = new Gtk.Grid ();
            diff_grid.attach (diff_header,0, 0, 1, 1);
            diff_grid.attach (date_diff_label,0, 1, 1, 1);
            diff_grid.attach (days_diff_label,0, 2, 1, 1);
            diff_grid.width_request = 370;
            
            
            var separator_diff = new Gtk.Separator (Gtk.Orientation.VERTICAL);
            separator_diff.margin_start = 8;
            separator_diff.margin_end = 8;
            separator_diff.height_request = 131;
            
            date_difference_view.attach (separator_diff, 1, 0, 1, 4);
            date_difference_view.attach (diff_grid, 2, 0, 1, 4);
            
            date_difference_view.height_request = 200;
            date_difference_view.margin_start = 8;
            date_difference_view.margin_end = 8;
            date_difference_view.margin_bottom = 8;
            date_difference_view.column_spacing = 8;
            date_difference_view.row_spacing = 4;
            
            // Make Add Date View
            // ----------------------------------------------------------------------------
            date_add_view = new Gtk.Grid ();
            var start_label = new Gtk.Label ("Starting from");
            start_label.xalign = 0;
            start_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            var add_label = new Gtk.Label ("Days to Add");
            add_label.xalign = 0;
            add_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            
            var date_input_grid = new Gtk.Grid ();
            var add_entry_day   = new Gtk.Entry ();
            add_entry_day.placeholder_text = "Day";
            add_entry_day.max_length  = 3;
            add_entry_day.width_chars = 6;
            add_entry_day.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY,"view-more-symbolic");
            var day_popper = new BottomPopper (add_entry_day);
            add_entry_day.icon_release.connect (() => {
                day_popper.set_visible (true);
            });
            add_entry_day.set_input_purpose (Gtk.InputPurpose.NUMBER);
            var add_entry_month = new Gtk.Entry ();
            add_entry_month.placeholder_text = "Month";
            add_entry_month.max_length  = 3;
            add_entry_month.width_chars = 6;
            add_entry_month.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY,"view-more-symbolic");
            var month_popper = new BottomPopper (add_entry_month);
            add_entry_month.icon_release.connect (() => {
                month_popper.set_visible (true);
            });
            add_entry_month.set_input_purpose (Gtk.InputPurpose.NUMBER);
            var add_entry_year  = new Gtk.Entry ();
            add_entry_year.placeholder_text = "Year";
            add_entry_year.max_length  = 3;
            add_entry_year.width_chars = 6;
            add_entry_year.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY,"view-more-symbolic");
            var year_popper = new BottomPopper (add_entry_year);
            add_entry_year.icon_release.connect (() => {
                year_popper.set_visible (true);
            });
            add_entry_year.set_input_purpose (Gtk.InputPurpose.NUMBER);
            date_input_grid.attach (add_entry_day, 0, 0, 1, 1);
            date_input_grid.attach (add_entry_month, 1, 0, 1, 1);
            date_input_grid.attach (add_entry_year, 2, 0, 1, 1);
            date_input_grid.column_spacing = 4;
            
            datepicker_add_sub  = new Granite.Widgets.DatePicker ();
            date_add_view.attach (start_label, 0, 0, 1, 1);
            date_add_view.attach (datepicker_add_sub, 0, 1, 1, 1);
            date_add_view.attach (add_label, 0, 2, 1, 1);
            date_add_view.attach (date_input_grid, 0, 3, 1, 1);
            
            
            date_add_view.height_request = 200;
            date_add_view.margin_start = 8;
            date_add_view.margin_end = 8;
            date_add_view.margin_bottom = 8;
            date_add_view.column_spacing = 8;
            date_add_view.row_spacing = 4;
            
            var add_header = new Gtk.Label ("The Date will be");
            add_header.xalign = 0;
            add_header.valign = Gtk.Align.START;
            add_header.width_request = 160;
            add_header.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            
            week_day_label = new Gtk.Label ("Wednesday");
            //week_day_label.xalign = 0;
            week_day_label.valign = Gtk.Align.END;
            week_day_label.halign = Gtk.Align.START;
            week_day_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
            date_dmy_label = new Gtk.Label ("January 31, 2019");
            //date_dmy_label.xalign = 0;
            date_dmy_label.halign = Gtk.Align.START;
            date_dmy_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            var add_grid = new Gtk.Grid ();
            add_grid.attach (add_header,0, 0, 1, 1);
            add_grid.attach (week_day_label,0, 1, 1, 1);
            add_grid.attach (date_dmy_label,0, 2, 1, 1);
            add_grid.width_request = 370;
            
            var main_calendar = new Gtk.Calendar ();
            main_calendar.set_display_options (Gtk.CalendarDisplayOptions.NO_MONTH_CHANGE);
            main_calendar.show_day_names = true;
            main_calendar.width_request = 210;
            add_grid.attach (main_calendar, 1, 0, 1, 3);
            
            var separator_add = new Gtk.Separator (Gtk.Orientation.VERTICAL);
            separator_add.margin_start = 8;
            separator_add.margin_end = 8;
            
            date_add_view.attach (separator_add, 1, 0, 1, 4);
            date_add_view.attach (add_grid, 2, 0, 1, 4);            
            
            var date_calc_holder = new Gtk.Stack ();
            date_calc_holder.add_named (date_difference_view, "Difference Between Dates");
            date_calc_holder.add_named (date_add_view, "Add or Subtract Dates");
            date_calc_holder.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            
            // Add events to Mode Button
            date_mode.set_active (0);
            date_mode.mode_changed.connect (() => {
                if (date_mode.selected == 0) {
                    date_calc_holder.set_visible_child (date_difference_view);
                    date_mode_stack.set_visible_child (date_diff_grid);
                }
                else if (date_mode.selected == 1){
                    date_calc_holder.set_visible_child (date_add_view);
                    date_mode_stack.set_visible_child (date_add_grid);
                }
                //stdout.printf ("%d\n", date_mode.selected);
            });
            
            date_calculator_object = new DateCalculator();
            
            datepicker_diff_from.changed.connect (() => {
                do_calculations ();
            });
            datepicker_diff_to.changed.connect (() => {
                do_calculations ();
            });
            
            attach (date_mode, 0, 0, 2, 1);
            attach (date_calc_holder, 0, 1, 1, 1);
            row_spacing = 54;
            halign = Gtk.Align.CENTER;
            valign = Gtk.Align.CENTER;
        }
        
        private void do_calculations () {
            datetime_diff_from = datepicker_diff_from.date;
            datetime_diff_to = datepicker_diff_to.date;
            string result_days = date_calculator_object.date_difference( datetime_diff_from , datetime_diff_to );
            result_days += (result_days == "1") ? " day" : " days";
            days_diff_label.set_text ("A total of " + result_days);
            
            DateFormatted formatted_date_difference = date_calculator_object.difference_formatter(datetime_diff_from , datetime_diff_to);
            string res_day = (formatted_date_difference.day).to_string ();
            string res_wek = (formatted_date_difference.week).to_string ();
            string res_mon = (formatted_date_difference.month).to_string ();
            string res_yar = (formatted_date_difference.year).to_string ();
            
            // Present the data with some LOVE
            string result_date = "";
            int part = 0;
            if (res_yar == "0" && res_mon == "0" && res_wek == "0" && res_day == "0") {
                result_date = "Hey, it's the same date \n ";
                days_diff_label.set_text ("");
            } else {
                if (res_yar != "0") {
                    result_date += (res_yar == "1") ? (((part == 0) ? "A" : "a") + " year") : (res_yar + " years");
                    part++;
                }
                if (res_mon != "0") {
                    if (res_day == "0" && res_wek == "0" && part > 0)
                        result_date += " and ";
                    else if (part > 0)
                        result_date += ", ";
                    result_date += (res_mon == "1") ? (((part == 0) ? "A" : "a") + " month") : (res_mon + " months");
                    part++;
                }
                if (res_wek != "0") {
                    if (res_day == "0" && part > 0)
                        result_date += " and ";
                    else if (part > 0)
                        result_date += ", ";
                    result_date += (res_wek == "1") ? (((part == 0) ? "1" : "a") + " week") : (res_wek + " weeks");
                    part++;
                }
                if (res_day != "0") {
                    if (part > 2)
                        result_date += "\n";
                    else if (part != 0)
                        result_date += " ";
                    if (part > 0)
                        result_date += "and ";
                    else
                        days_diff_label.set_text ("");
                    result_date += (res_day == "1") ? (((part == 0) ? "A" : "a") + " day") : (res_day + " days");
                }
            }
            date_diff_label.set_text (result_date);
        }
    }
    public class BottomPopper : Gtk.Popover {
        Gtk.Grid main_grid;
        Gtk.Button plus_button;
        Gtk.Button plus_10_button;
        Gtk.Button minus_button;
        Gtk.Button minus_10_button;
        Gtk.Entry entry;
        construct {
            main_grid = new Gtk.Grid ();
            plus_button  = new Gtk.Button.with_label (" + ");
            minus_button = new Gtk.Button.with_label (" − ");
            plus_10_button  = new Gtk.Button.with_label ("+10");
            plus_10_button.get_style_context ().add_class ("Pebbles_Buttons_Function");
            minus_10_button = new Gtk.Button.with_label ("−10");
            minus_10_button.get_style_context ().add_class ("Pebbles_Buttons_Function");
            
            plus_button.clicked.connect (() => {
                int i = int.parse (entry.get_text ());
                i++;
                entry.set_text (i.to_string ());
            });
            
            minus_button.clicked.connect (() => {
                int i = int.parse (entry.get_text ());
                if (i > 0)
                    i--;
                else if (i <= 0) {
                    i = 0;
                }
                if (i == 0) 
                    entry.set_text ("");
                else 
                    entry.set_text (i.to_string ());
            });
            
            plus_10_button.clicked.connect (() => {
                int i = int.parse (entry.get_text ());
                i+=10;
                entry.set_text (i.to_string ());
            });
            
            minus_10_button.clicked.connect (() => {
                int i = int.parse (entry.get_text ());
                if (i > 10)
                    i-=10;
                else if (i <= 10) {
                    i = 0;
                }
                if (i == 0) 
                    entry.set_text ("");
                else 
                    entry.set_text (i.to_string ());
            });
            
            main_grid.attach (plus_10_button,  0, 0, 1, 1);
            main_grid.attach (plus_button,     1, 0, 1, 1);
            main_grid.attach (minus_button,    2, 0, 1, 1);
            main_grid.attach (minus_10_button, 3, 0, 1, 1);
            main_grid.column_spacing = 4;
            main_grid.margin = 4;

            this.add (main_grid);
        }
        public BottomPopper (Gtk.Entry entry) {
            this.entry = entry;
            this.set_relative_to (entry);
            this.show_all ();
            this.set_visible (false);
            this.position = Gtk.PositionType.BOTTOM;
        }
    }
}