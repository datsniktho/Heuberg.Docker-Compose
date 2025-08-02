CREATE TABLE "creditor"(
    "id" SERIAL NOT NULL,
    "des" VARCHAR(255) NOT NULL,
    "iban" VARCHAR(255) NULL,
    "mail" VARCHAR(255) NOT NULL,
    "address" VARCHAR(255) NOT NULL,
    "countrycode" VARCHAR(255) NULL,
    "datecreate" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "creditor" ADD PRIMARY KEY("id");

CREATE TABLE "invoicehead"(
    "id" BIGSERIAL NOT NULL,
    "des" VARCHAR(255) NOT NULL,
    "creid" INTEGER NOT NULL,
    "invoicetypeid" SMALLINT NOT NULL,
    "beldat" DATE NOT NULL,
    "receiptext" VARCHAR(255) NOT NULL,
    "amount" DECIMAL(8, 2) NOT NULL,
    "statusid" SMALLINT NOT NULL,
    "datecreate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "categoryid" SMALLINT NULL
);
CREATE INDEX "invoicehead_statusid_index" ON
    "invoicehead"("statusid");
CREATE INDEX "invoicehead_creid_index" ON
    "invoicehead"("creid");
CREATE INDEX "invoicehead_invoicetypeid_index" ON
    "invoicehead"("invoicetypeid");
CREATE INDEX "invoicehead_beldat_index" ON
    "invoicehead"("beldat");
ALTER TABLE
    "invoicehead" ADD PRIMARY KEY("id");

CREATE TABLE "documents"(
    "id" BIGSERIAL NOT NULL,
    "des" VARCHAR(255) NOT NULL,
    "invoiceid" BIGINT NOT NULL,
    "doctypeid" SMALLINT NOT NULL,
    "datecreate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "filepath" TEXT NOT NULL,
    "fileextension" VARCHAR(255) NOT NULL
);
CREATE INDEX "documents_invoiceid_index" ON
    "documents"("invoiceid");
CREATE INDEX "documents_doctypeid_index" ON
    "documents"("doctypeid");
ALTER TABLE
    "documents" ADD PRIMARY KEY("id");

CREATE TABLE "invoicepos"(
    "pos" SMALLINT GENERATED ALWAYS AS IDENTITY,
    "invoiceid" BIGINT NOT NULL
);
CREATE INDEX "invoicepos_invoiceid_index" ON
    "invoicepos"("invoiceid");
ALTER TABLE
    "invoicepos" ADD PRIMARY KEY("pos","invoiceid");

CREATE TABLE "documenttype"(
    "id" SMALLINT GENERATED ALWAYS AS IDENTITY,
    "des" VARCHAR(255) NOT NULL,
    "datecreate" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "documenttype" ADD PRIMARY KEY("id");

CREATE TABLE "invoicetype"(
    "id" SMALLINT GENERATED ALWAYS AS IDENTITY,
    "des" VARCHAR(255) NOT NULL,
    "datecreate" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "invoicetype" ADD PRIMARY KEY("id");

CREATE TABLE "status"(
    "id" SMALLINT GENERATED ALWAYS AS IDENTITY,
    "des" VARCHAR(255) NOT NULL,
    "prioritystate" VARCHAR(255) CHECK
        (
            "prioritystate" IN('low', 'medium', 'high')
        ) NOT NULL,
    "datecreate" DATE NOT NULL DEFAULT CURRENT_DATE
);
CREATE INDEX "status_prioritystate_index" ON
    "status"("prioritystate");
ALTER TABLE
    "status" ADD PRIMARY KEY("id");

CREATE TABLE "category"(
    "id" SMALLINT GENERATED ALWAYS AS IDENTITY,
    "des" VARCHAR(255) NOT NULL,
    "datecreate" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "category" ADD PRIMARY KEY("id");

ALTER TABLE
    "invoicepos" ADD CONSTRAINT "invoicepos_invoiceid_foreign" FOREIGN KEY("invoiceid") REFERENCES "invoicehead"("id");
ALTER TABLE
    "invoicehead" ADD CONSTRAINT "invoicehead_categoryid_foreign" FOREIGN KEY("categoryid") REFERENCES "category"("id");
ALTER TABLE
    "documents" ADD CONSTRAINT "documents_invoiceid_foreign" FOREIGN KEY("invoiceid") REFERENCES "invoicehead"("id");
ALTER TABLE
    "invoicehead" ADD CONSTRAINT "invoicehead_invoicetypeid_foreign" FOREIGN KEY("invoicetypeid") REFERENCES "invoicetype"("id");
ALTER TABLE
    "documents" ADD CONSTRAINT "documents_doctypeid_foreign" FOREIGN KEY("doctypeid") REFERENCES "documenttype"("id");
ALTER TABLE
    "invoicehead" ADD CONSTRAINT "invoicehead_statusid_foreign" FOREIGN KEY("statusid") REFERENCES "status"("id");
ALTER TABLE
    "invoicehead" ADD CONSTRAINT "invoicehead_creid_foreign" FOREIGN KEY("creid") REFERENCES "creditor"("id");