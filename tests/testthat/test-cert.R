test_that("system and server cert stores are concatenated", {
  local_temp_config()

  serverCertificateFile <- test_path("certs/localhost.pem")
  serverCertificate <- paste(
    c(
      # this in-memory certificate has duplication, which
      # is removed in the concatenated result.
      readLines(con = serverCertificateFile, warn = FALSE),
      readLines(con = serverCertificateFile, warn = FALSE)
    ),
    collapse = "\n"
  )

  caCertificateFile <- test_path("certs/example.com.pem")

  withr::local_options(rsconnect.ca.bundle = caCertificateFile)

  # create and then read the temporary certificate file
  concatenated <- createCertificateFile(serverCertificate)
  withr::defer(unlink(concatenated))

  # the result is the concatenation (ca first) without duplicates.
  expect_equal(
    openssl::read_cert_bundle(concatenated),
    openssl::read_cert_bundle(
      paste0(
        sapply(
          c(
            openssl::read_cert_bundle(caCertificateFile),
            openssl::read_cert_bundle(serverCertificateFile)
          ),
          openssl::write_pem
        ),
        collapse = ""
      )
    )
  )
})

test_that("invalid certificates cannot be added", {
  local_temp_config()

  expect_error(addTestServer(
    url = "https://localhost:4567/",
    name = "cert_test_e",
    certificate = test_path("certs/invalid.crt")
  ))
})

test_that("certificates not used when making plain http connections", {
  local_temp_config()
  local_http_recorder()

  GET(
    list(
      protocol = "http",
      host = "localhost:4567",
      port = "80",
      path = "apps"
    ),
    authInfo = list(certificate = test_path("certs/localhost.pem")),
    "apps"
  )
  expect_equal(httpLastRequest$certificate, NULL)
})

test_that("certificates used when making https connections", {
  local_temp_config()
  local_http_recorder()

  GET(
    list(
      protocol = "https",
      host = "localhost:4567",
      port = "443",
      path = "apps"
    ),
    authInfo = list(certificate = test_path("certs/localhost.pem")),
    "apps"
  )

  # we expect to get a cert file
  expect_true(file.exists(httpLastRequest$certificate))

  # clean up
  unlink(httpLastRequest$certificate)
})
