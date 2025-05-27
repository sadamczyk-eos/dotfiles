# Work specific configs

if status is-interactive
    abbr -a -- s 'cd ~/Projects/shops'
    abbr -a -- back 'docker compose exec php-backend bash'
    abbr -a -- elastic 'docker compose exec elasticsearch bash'
    abbr -a -- front 'docker compose exec php-frontend bash'
    abbr -a -- redis 'docker compose exec redis redis-cli'
    abbr -a -- start 'docker compose --profile "*" up --build -d && sleep 90 && ./update.sh'
    abbr -a -- supervisorctl 'docker compose exec rabbitmq-consumers supervisorctl'
    abbr -a -- clc docker compose\ run\ --rm\ php-backend\ find\ \'app/cache/\'\ \'public/published_elements/\'\ -maxdepth\ 1\ -mindepth\ 1\ -type\ d\ -exec\ rm\ -rf\ \'\{\}\'\ \\\;\ \&\&\ echo\ \'Cleared\ backend\ cache\'\;\ docker compose\ run\ --rm\ php-frontend\ find\ \'app/cache/\'\ -maxdepth\ 1\ -mindepth\ 1\ -type\ d\ -exec\ rm\ -rf\ \'\{\}\'\ \\\;\ \&\&\ echo\ \'Cleared\ frontend\ cache\'\;
    # cll = CLear symLinks
    abbr -a -- cll find . -type l -iwholename \'\*/vendor/eos/\*\' -exec rm {} \\\;
    abbr -a -- upd ./update.sh
    abbr -a -- pre ./pre-commit.sh
    abbr -a -- kr kuberun
    abbr -a -- kl 'kubectl logs '
    # rcl = Regenerate Composer Locks
    abbr -a -- rcl 'rm -f backend/composer.lock && docker compose run --rm php-backend composer install --prefer-dist --no-interaction && rm -f frontend/composer.lock && docker compose run --rm php-frontend composer install --prefer-dist --no-interaction'
    abbr -a -- rclb 'rm -f backend/composer.lock && docker compose run --rm php-backend composer install --prefer-dist --no-interaction'
    abbr -a -- rclf 'rm -f frontend/composer.lock && docker compose run --rm php-frontend composer install --prefer-dist --no-interaction'
    # rhl = Regenerate Helm Lock
    abbr -a -- rhl 'rm -f k8s/helm/*/Chart.lock ; helm dep update k8s/helm/*/ ;'
end

export EOS_SHOP_ENV="$HOME/Projects/misc/env"
export EOS_FRAMEWORK_PATH="$HOME/Projects/eos"
export PATH="$HOME/Projects/pastebin/bin:$HOME/Projects/sadamczyk/bin/bin:$PATH"
