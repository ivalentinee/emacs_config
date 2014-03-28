;; calendar-settings.el

;; Calendar settings is copy-paste from Emacs wiki
;;   http://www.emacswiki.org/emacs/CalendarLocalization
;; Nothing special

;; European style of dates
(add-hook 'calendar-load-hook
              (lambda ()
                (calendar-set-date-style 'european)))

;; Russian localization
(setq calendar-week-start-day 1
          calendar-day-name-array ["Вс" "Пн" "Вт" "Ср" "Чт" "Пт" "Сб"]
          calendar-month-name-array ["Январь" "Февраль" "Март" "Апрель" "Май" 
                                     "Июнь" "Июль" "Август" "Сентябрь"
                                     "Октябрь" "Ноябрь" "Декабрь"])

(provide 'calendar-settings)