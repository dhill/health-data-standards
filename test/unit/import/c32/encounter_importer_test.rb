require 'test_helper'

class EncounterImporterTest < MiniTest::Unit::TestCase
  def test_encounter_importing
    doc = Nokogiri::XML(File.new('test/fixtures/NISTExampleC32.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = HealthDataStandards::Import::C32::PatientImporter.instance
    patient = pi.parse_c32(doc)
    
    encounter = patient.encounters[0]
    assert encounter.codes['CPT'].include? '99241'
    assert_equal encounter.performer['person']['name'], 'Dr. Kildare'
    assert_equal encounter.facility['organizationName'], 'Good Health Clinic'
    assert encounter.reason.codes['SNOMED-CT'].include? '308292007'
    assert_equal encounter.admit_type['code'], 'xyzzy'
    assert_equal encounter.admit_type['codeSystem'], 'CPT'
  end
end