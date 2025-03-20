function l --wraps ls --description "List contents of directory using long format"
    eza -l --smart-group --icons $argv
end
