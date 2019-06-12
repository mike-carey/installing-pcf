#!/usr/bin/env bats

load helpers/print/bprint

FLY_TARGET=lite
TERRAFORM_DIR=./terraform
TMP_DIR=$BATS_TEST_DIRNAME/_output/terraform


@test "It should initialize .terraform directory" {
  rm -rf $TMP_DIR
  mkdir -p $TMP_DIR

  cp -r $TERRAFORM_DIR $TMP_DIR/code

  run fly -t $FLY_TARGET \
    execute --include-ignored \
    -c ../tasks/terraform-init.yml \
    -i code=$TMP_DIR/code \
    -o initialized-code=$TMP_DIR/initialized-code

  [ $status -eq 0 ]

  [[ -d $TMP_DIR/initialized-code/.terraform ]]
}

@test "It should create a terraform plan" {
  run fly -t $FLY_TARGET \
    execute --include-ignored \
    -c ../tasks/terraform-plan.yml \
    -i initialized-code=$TMP_DIR/initialized-code \
    -o plan=$TMP_DIR/plan

  [ $status -eq 0 ]

  [[ -f $TMP_DIR/plan/plan ]]
}

@test "It should apply a terraform plan" {
  run fly -t $FLY_TARGET \
    execute --include-ignored \
    -c ../tasks/terraform-apply.yml \
    -i initialized-code=$TMP_DIR/initialized-code \
    -i plan=$TMP_DIR/plan \
    -o updated-state=$TMP_DIR/updated-state

  [ $status -eq 0 ]

  [[ -f $TMP_DIR/updated-state/terraform.tfstate ]]
}
