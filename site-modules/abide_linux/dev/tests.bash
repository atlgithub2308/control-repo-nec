#!/bin/bash

COLLECTION="puppet6"
PROVISION="default"
TEARDOWN="yes"


function get_help {
    echo "tests.bash provides an easy way to launch the test suite for Abide"
    echo
    echo "Syntax: ./tests.bash -[a|l|v|u|t|C|L|P|E]..."
    echo "options:"
    echo "-a         Run all test suites"
    echo "-l         Run Litmus tests (acceptance tests)"
    echo "-v         Run pdk validate --parallel"
    echo "-u         Run pdk test unit --parallel"
    echo "-t         Same as -l but does not tear down container after test"
    echo "-s         Run spellcheck against README (uses aspell)"
    echo "-C <val>   Set the collection for Litmus agents (puppet5, puppet6, puppet)"
    echo "-L <val>   Set the provision list for Litmus machines (default)"
    echo "-P <val>   Set the Puppet version for unit tests. Takes Puppet semver string."
    echo "-E <val>   Set the PE version for unit tests. Takes a PE version string."
}

function validate {
    $(command -v pdk) validate --parallel
}

function unit {
    if [ -z "$PEVER" ] && [ -z "$PUPVER" ]; then
        $(command -v pdk) test unit --parallel
    elif [ -z "$PEVER" ]; then
        echo "Running unit tests against Puppet version ${PUPVER}..."
        $(command -v pdk) test unit --parallel --puppet-version "${PUPVER}"
    else
        echo "Running unit tests against PE version ${PEVER}..."
        $(command -v pdk) test unit --parallel --pe-version "${PEVER}"
    fi
}

function litmus {
    echo "Provisioning test hosts from list ${PROVISION}..."
    $(command -v pdk) bundle exec rake "litmus:provision_list[${PROVISION}]"
    echo "Installing agents from collection ${COLLECTION}..."
    $(command -v pdk) bundle exec rake "litmus:install_agent[${COLLECTION}]"
    $(command -v pdk) bundle exec rake 'litmus:install_module'
    $(command -v pdk) bundle exec rake 'litmus:acceptance:parallel'
    if [ "$TEARDOWN" = "yes" ]; then
        echo "Tearing down test hosts..."
        $(command -v pdk) bundle exec rake 'litmus:tear_down'
    else
        echo "Not tearing down test hosts due to -t flag..."
    fi
}

function spellcheck {
    echo "Checking spelling in README.md..."
    $(command -v aspell) --lang=en_US --add-wordlists=dev/aspell.txt --mode=markdown \
    --sug-mode=fast --ignore-case --dont-backup --dont-save-repl check README.md
    echo "Done with spell check."
}

function main {
    echo "Starting test suites..."
    c=("$@")
    for i in "${c[@]}"; do
        eval "${i}"
    done
}

unset cmd
declare -a cmd
while getopts ':halstuvC:P:E:L:' opt; do
    case ${opt} in
        a) cmd[0]="validate"
           cmd[1]="unit"
           cmd[2]="litmus"
           ;;
        l) cmd[0]="litmus"
           ;;
        s) cmd[0]="spellcheck"
           ;;
        t) TEARDOWN="no"
           ;;
        u) cmd[0]="unit"
           ;;
        v) cmd[0]="validate"
           ;;
        C) COLLECTION=$OPTARG
           ;;
        P) PUPVER=$OPTARG
           ;;
        E) PEVER=$OPTARG
           ;;
        L) PROVISION=$OPTARG
           ;;
        h | *) cmd[0]="get_help"
               cmd[1]="exit 0"
               ;;
    esac
done

if [ -z "${cmd[0]}" ]; then
  echo "Please select a test suite to run..."
  echo
  get_help
  exit 1
else
  main "${cmd[@]}"
fi
