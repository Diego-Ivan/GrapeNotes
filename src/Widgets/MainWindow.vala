namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/MainWindow.ui")]
    public class MainWindow : Adw.ApplicationWindow {
        static construct {
            typeof (View).ensure ();
        }
        public MainWindow (Application app) {
            Object (
                application: app
            );
        }
    }
}
