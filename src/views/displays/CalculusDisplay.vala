/*-
 * Copyright (c) 2018-2019 Subhadeep Jasu <subhajasu@gmail.com>
 * Copyright (c) 2018-2019 Saunak Biswas  <saunakbis97@gmail.com>
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
 */

namespace Pebbles {
    public class CalculusDisplay : Gtk.Grid {
        // Status bar
        Gtk.Grid lcd_status_bar;
        Gtk.Label deg_label;
        Gtk.Label rad_label;
        Gtk.Label grad_label;
        Gtk.Label memory_label;
        Gtk.Label shift_label;

        // Answer label
        public Gtk.Label answer_label;

        // Input entry
        public Gtk.Entry input_entry;

        // Angle mode
        GlobalAngleUnit angle_mode;
        
        construct {
            calc_make_display_ui ();
        }
        
        void calc_make_display_ui () {
            // Stylize background;
            get_style_context ().add_class ("Pebbles_Display_Unit_Bg");
            
            // Make status bar
            lcd_status_bar = new Gtk.Grid ();
            deg_label      = new Gtk.Label ("DEG");
            deg_label.get_style_context ().add_class ("pebbles_h4");
            rad_label      = new Gtk.Label ("RAD");
            rad_label.get_style_context ().add_class ("pebbles_h4");
            grad_label     = new Gtk.Label ("GRA");
            grad_label.get_style_context ().add_class ("pebbles_h4");
            memory_label   = new Gtk.Label ("M");
            memory_label.get_style_context ().add_class ("pebbles_h4");
            memory_label.set_opacity (0.2);
            shift_label    = new Gtk.Label ("SHIFT");
            shift_label.get_style_context ().add_class ("pebbles_h4");
            shift_label.set_opacity (0.2);

            var angle_mode_display = new Gtk.Grid ();
            angle_mode_display.attach (deg_label,  0, 0, 1, 1);
            angle_mode_display.attach (rad_label,  1, 0, 1, 1);
            angle_mode_display.attach (grad_label, 2, 0, 1, 1);
            angle_mode_display.column_spacing = 10;

            lcd_status_bar.attach (angle_mode_display, 0, 0, 1, 1);
            lcd_status_bar.attach (memory_label, 1, 0, 1, 1);
            lcd_status_bar.attach (shift_label, 2, 0, 1, 1);
            lcd_status_bar.column_spacing = 205;
            lcd_status_bar.width_request = 530;
            lcd_status_bar.set_halign (Gtk.Align.END);

            // Make LCD Answer label
            answer_label = new Gtk.Label ("0");
            answer_label.set_halign (Gtk.Align.END);
            answer_label.get_style_context ().add_class ("pebbles_h1");
            var scrollable = new Gtk.ScrolledWindow (null, null);
            scrollable.add (answer_label);
            scrollable.propagate_natural_height = true;
            scrollable.shadow_type = Gtk.ShadowType.NONE;
            scrollable.get_style_context ().add_class ("pebbles_h1");

            // Make Input entry
            input_entry = new Gtk.Entry ();

            input_entry.set_has_frame (false);
            input_entry.set_text ("0");
            input_entry.get_style_context ().add_class ("pebbles_h2");
            input_entry.set_halign (Gtk.Align.START);
            input_entry.width_request = 530;
            input_entry.max_width_chars = 39;

            // Make seperator
            Gtk.Separator lcd_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            lcd_separator.set_opacity (0.6);

            // Put it together
            attach (lcd_status_bar, 0, 0, 1, 1);
            attach (scrollable, 0, 1, 1, 1);
            attach (lcd_separator, 0, 2, 1, 1);
            attach (input_entry, 0, 3, 1, 1);

            width_request = 530;
        }

        public void set_shift_enable (bool s_on) {
            if (s_on) {
                shift_label.set_opacity (1);
            }
            else {
                shift_label.set_opacity (0.2);
            }
        }
        
        public void set_angle_status (int state) {
            switch (state) {
                case 1 :
                    deg_label.set_opacity  (0.2);
                    rad_label.set_opacity  (1);
                    grad_label.set_opacity (0.2);
                    angle_mode = GlobalAngleUnit.RAD;
                    break;
                case 2 :
                    deg_label.set_opacity  (0.2);
                    rad_label.set_opacity  (0.2);
                    grad_label.set_opacity (1);
                    angle_mode = GlobalAngleUnit.GRAD;
                    break;
                default :
                    deg_label.set_opacity  (1);
                    rad_label.set_opacity  (0.2);
                    grad_label.set_opacity (0.2);
                    angle_mode = GlobalAngleUnit.DEG;
                    break;
            }
        }

        public void set_memory_status (bool state) {
            if (state) {
                memory_label.set_opacity (1);
            }
            else {
                memory_label.set_opacity (0.2);
            }
        }
    }
}