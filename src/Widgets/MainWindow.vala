namespace GrapeNotes {
    [GtkTemplate (ui = "/io/github/diegoivan/Grape-Notes/ui/MainWindow.ui")]
    public class MainWindow : Adw.ApplicationWindow {
        public MainWindow (Application app) {
            Object (
                application: app
            );
        }
    }
}
