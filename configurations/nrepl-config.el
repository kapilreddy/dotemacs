(require 'nrepl)

(add-hook 'nrepl-interaction-mode-hook
          'nrepl-turn-on-eldoc-mode)

(setq nrepl-tab-command 'indent-for-tab-command)

(setq nrepl-popup-stacktraces nil)
(add-hook 'nrepl-mode-hook 'subword-mode)
(add-hook 'nrepl-mode-hook 'paredit-mode)
(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)
