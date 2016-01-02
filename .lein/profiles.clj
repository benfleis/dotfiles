{:user {:plugins [[cider/cider-nrepl "0.9.0-SNAPSHOT"]
                  [lein-midje "3.1.3"]
                  [refactor-nrepl "1.0.5"]]
        :dependencies [[org.clojure/tools.nrepl "0.2.10" :exclusions [[org.clojure/clojure]]]
                       [io.aviso/pretty "0.1.17"]]
        :jvm-opts ["-Dapple.awt.UIElement=true"
                   #_"-Djava.awt.headless=true"
                   #_"-Dawt.toolkit=sun.awt.HToolkit"
                   "-XX:-OmitStackTraceInFastThrow"]}

 :repl-options {;; If nREPL takes too long to load it may timeout,
                ;; increase this to wait longer before timing out.
                ;; Defaults to 30000 (30 seconds)
                :timeout 120000

                ;; https://portal.aviso.io/#/document/open-source/pretty/Current/repl.html
                ;; pretty print exceptions in the repl
                :nrepl-middleware [io.aviso.nrepl/pretty-middleware]}}
