function pod_grep() {
  kubectl -n "$1" get pods | grep "$2"
}

function pod_list() {
  kubectl -n "$1" get pods "${@:2}"
}

function pod_kill() {
  kubectl -n "$1" delete pod "${@:2}"
}

function pod_shell() {
  kubectl -n "$1" exec -it "${@:2}" /bin/bash
}

function log_service() {
  stern -n "$1" "$2"
}

function get_namespaces() {
  kubectl get namespaces
}

function neo-port-forward() {
  if [ -z "$1" ] ; then
    neo_node='0'
  else
    neo_node="$1"
  fi
  kubectl port-forward "neo4j-core-$neo_node" 7474:7474 7687:7687
}

function neo() {
  if [ -z "$1" ] ; then
    neo_node='0'
  else
    neo_node="$1"
  fi

  kubectl exec -it "neo4j-$neo_node" -- /var/lib/neo4j/bin/cypher-shell -u neo4j
}

function drestart() {
  docker stop "$1"
  make "$1" start
}

alias ddcom='docker-compose -p devenv -f /Users/josh.marchello/dev/platform/docker-compose.yml'

alias init-pre-commit="brew install pre-commit && pre-commit install && pre-commit install --install-hooks && pre-commit install --hook-type pre-push"

alias argocd-web="echo 'go to localhost:8080' && kubectl -n argocd port-forward svc/argocd-server -n argocd 8080:443"

export AWS_VAULT_KEYCHAIN_NAME=login
export KUBECONFIG=~/.kube/config

alias dlogin="aws-vault exec grx-tech -- task aws-login"

source <(argo completion zsh)