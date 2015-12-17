# Introduction

helm-ash.el is [helm](http://emacs-helm.github.io/helm/) interface for [ash](https://github.com/seletskiy/ash).

# Setup

Clone this repo. Add path to repo directory into load path & require
into your Emacs init file.

```elisp
(add-to-list 'load-path "/path/to/helm-ash/repo")
(require 'helm-ash)
(global-set-key (kbd "C-x c C-r") 'helm-ash-inbox)
```
