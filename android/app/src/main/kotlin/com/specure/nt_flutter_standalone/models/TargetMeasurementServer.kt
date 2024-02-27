package com.specure.nt_flutter_standalone.models

data class TargetMeasurementServer(
  val encrypted: Boolean = true,
  val port: Int,
  val address: String,
  val id: Int,
  val serverType: String
)
