import fixtureTranscriptTest from './FixtureTranscript.test';
import voiceCoreTest from './VoiceCore.test';

export default function testsuite(): void {
  fixtureTranscriptTest();
  voiceCoreTest();
}
