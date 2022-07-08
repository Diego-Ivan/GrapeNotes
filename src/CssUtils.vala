/* CssUtils.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GrapeNotes.CssUtils {
    public string font_description_to_css (Pango.FontDescription font_description) {
        string css = "";
        Pango.FontMask mask = font_description.get_set_fields ();

        if (FAMILY in mask) {
            string family = font_description.get_family ();
            css += "font-family: \"%s\";".printf (family);
        }

        if (STYLE in mask) {
            switch (font_description.get_variant ()) {
                case NORMAL:
                    css += "font-variant: normal;";
                    break;

                case SMALL_CAPS:
                    css += "font-variant: small-caps;";
                    break;

                case ALL_SMALL_CAPS:
                    css += "font-variant: all-small-caps;";
                    break;

                case PETITE_CAPS:
                    css += "font-variant: petite-caps;";
                    break;

                case ALL_PETITE_CAPS:
                    css += "font-variant: all-petite-caps;";
                    break;

                case UNICASE:
                    css += "font-variant: unicase;";
                    break;

                case TITLE_CAPS:
                    css += "font-variant: titling-caps;";
                    break;
            }
        }

        if (WEIGHT in mask) {
            int weight = font_description.get_weight ();
            switch (weight) {
                case Pango.Weight.SEMIBOLD:
                case Pango.Weight.NORMAL:
                    css += "font-weight: normal;";
                    break;

                case Pango.Weight.BOLD:
                    css += "font-weight: bold;";
                    break;

                case Pango.Weight.THIN:
                case Pango.Weight.ULTRALIGHT:
                case Pango.Weight.LIGHT:
                case Pango.Weight.BOOK:
                case Pango.Weight.MEDIUM:
                case Pango.Weight.ULTRABOLD:
                case Pango.Weight.HEAVY:
                case Pango.Weight.ULTRAHEAVY:
                    /* Round to the nearest hundred */
                    weight =  (int) Math.round (weight / 100) * 100;
                    css += "font-weight: %i;".printf (weight);
                    break;
            }
        }

        if (STRETCH in mask) {
            switch (font_description.get_stretch ()) {
                case ULTRA_CONDENSED:
                    css += "font-stretch: ultra-condensed;";
                    break;

                case EXTRA_CONDENSED:
                    css += "font-stretch: extra-condensed;";
                    break;

                case CONDENSED:
                    css += "font-stretch: condensed;";
                    break;

                case SEMI_CONDENSED:
                    css += "font-stretch: semi-condensed;";
                    break;

                case NORMAL:
                    css += "font-stretch: normal;";
                    break;

                case SEMI_EXPANDED:
                    css += "font-stretch: semi-expanded;";
                    break;

                case EXPANDED:
                    css += "font-stretch: expanded;";
                    break;

                case EXTRA_EXPANDED:
                    css += "font-stretch: extra-expanded;";
                    break;

                case ULTRA_EXPANDED:
                    css += "font-stretch: ultra-expanded;";
                    break;
            }
        }

        if (SIZE in mask) {
            int size = font_description.get_size () / Pango.SCALE;
            css += "font-size: %ipt;".printf (size);
        }

        return css;
    }
}
